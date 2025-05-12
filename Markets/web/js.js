const Garages = new Vue({
    el: ".Markets",
    data: {
        active: false,
        zoom: 1,

        selectedCategory: "Mancare",
        paymentMethod: 'Cash',

        MarketItems: {},

        Bsket: [],
    },

    mounted() {
        this.handleResize();

        window.addEventListener("resize", this.handleResize);
        window.addEventListener("message", this.onMessage);
        window.addEventListener("keydown", this.onKey);
    },

    methods: {
        async post(url, data = {}) {
            try {
                const response = await fetch(`https://${GetParentResourceName()}/${url}`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
            
                if (response.ok) {
                    return await response.json();
                } else {
                    throw new Error(`${response.status}`);
                }
            } catch (error) {
                return null;
            }
        },

        handleResize() {
            var zoomCountOne = window['innerWidth'] / 1920;
            var zoomCountTwo = window['innerHeight'] / 1080;

            if (zoomCountOne < zoomCountTwo) {
                this['zoom'] = zoomCountOne;
            } else {
                this['zoom'] = zoomCountTwo;
            }
        },

        closeUI() {
            this.post("Nui:setFocus", [false]);
            $(".Markets").addClass("Close")
            setTimeout(() => {
                $(".Markets").removeClass("Close")

                this.active = false; this.Bsket = []; this.totalPrice = 0; this.paymentMethod = 'Cash'; this.selectedCategory = 'Mancare'
            }, 390);
        },

        isItemInCart(name) {
            var data = this.Bsket.filter((item) => item.name == name);
            return data[0] ? data[0] : false;
        },

        addOrRemove(event, name, item) {
            if (event.button === 0) {
                this.add(name, item);
            } else if (event.button === 2) {
                this.remove(name);
            }
        },

        add(name, item) {
            if (this.isItemInCart(name)) {
                var data = this.Bsket.filter((item) => item.name == name);
                data[0].amount++;
            } else {
                var newItem = {
                    name: name,
                    label: item,
                    amount: 1,
                    category: this.MarketItems[item][2],
                    price: this.MarketItems[item][1]
                };
                this.Bsket.push(newItem);

                var sound = new Audio("sounds/adauga.MP3");
                sound.volume = 0.4;
                sound.play();
            }
        },

        remove(name) {
            let itemInCart = this.isItemInCart(name);
            if (itemInCart) {
                itemInCart.amount--;
                if (itemInCart.amount <= 0) {
                    this.Bsket = this.Bsket.filter(item => item.name !== name);
                }
            }
        },

        buy(paymentMethod) {
            if (this.Bsket.length === 0) {return}

            this.post("Nui:marketBuy", {shoppingCart: this.Bsket, method: paymentMethod});

            var sound = new Audio("sounds/plateste.MP3");
            sound.volume = 0.4;
            sound.play();

            this.closeUI();
        },

        onKey(event) {
            var theKey = event.code;
            
            switch(true) {
                case (theKey == "Escape" && this.active):
                    this.closeUI();
                break
            }
        },

        onMessage() {
            var data = event.data

            switch(data.act) {
                case "openMarket":
                    this.active = true
                    this.MarketItems = data.items
                    this.post("Nui:setFocus", [true]);
                break
            }
        }
    }
});
