var autoTransition = {
    secondsPerSlide: 20,

    start: function() {
        if(!autoTransition.timer) {
            autoTransition.timer = setInterval(autoTransition.countDown, 1000);
        }
        autoTransition.setControlElementToStop();
        autoTransition.updateTimerElement();
        autoTransition.resetElement.innerHTML = "<a href='#' onClick='autoTransition.reset();'>reset</a>";
        if(slidenum == 0) {
            nextSlide(false);
        }
    },

    stop: function() {
        clearInterval(autoTransition.timer);
        autoTransition.timer = null;
        autoTransition.setControlElementToStart();
    },

    reset: function() {
        autoTransition.countDownToNextSlide = autoTransition.secondsPerSlide;
        autoTransition.finish();
    },

    finish: function() {
        autoTransition.stop();
        autoTransition.resetElement.innerHTML = "";
        autoTransition.timerElement.innerHTML = "";
    },

    countDown: function() {
        autoTransition.countDownToNextSlide -= 1;
        if (autoTransition.countDownToNextSlide <= 0) {
            autoTransition.countDownToNextSlide = autoTransition.secondsPerSlide;
            if (slidenum < slides.length - 1) {
                nextSlide(false);
            } else { // finished last slide
                autoTransition.finish();
                return; // prevent updateTimerElement from being called
            }
        }
        autoTransition.updateTimerElement();
    },

    updateTimerElement: function() {
        autoTransition.timerElement.innerHTML = String(autoTransition.countDownToNextSlide) + "s";
    },

    setControlElementToStart: function() {
        autoTransition.controlElement.innerHTML = "<a href='#' onClick='autoTransition.start();'>start</a>";
    },

    setControlElementToStop: function() {
        autoTransition.controlElement.innerHTML = "<a href='#' onClick='autoTransition.stop();'>stop</a>";
    },

    initialize: function() {
        // By initializing the number of seconds until next slide transition here in stead
        // of in start(), start() can also be used to continue where we left off
        autoTransition.countDownToNextSlide = autoTransition.secondsPerSlide;

        autoTransition.setControlElementToStart();
    },

    createControlElement: function() {
        autoTransition.controlElement = document.createElement("div");
        autoTransition.controlElement.innerHTML = "control";
        autoTransition.controlElement.setAttribute("style", "display: inline");

        return autoTransition.controlElement;
    },

    createTimerElement: function() {
        autoTransition.timerElement = document.createElement("div");
        autoTransition.timerElement.setAttribute("style", "display: inline");
        return autoTransition.timerElement;
    },

    createResetElement: function() {
        autoTransition.resetElement = document.createElement("div");
        autoTransition.resetElement.setAttribute("style", "display: inline");
        return autoTransition.resetElement;
    },

    createSpacerElement: function(n) {
        if (!n) {
            n = 2;
        }
        var s = "";
        for(var i = 0; i < n; i += 1) {
            s += "&nbsp;"
        }
        autoTransition.spacerElement = document.createElement("div");
        autoTransition.spacerElement.innerHTML = s;
        autoTransition.spacerElement.setAttribute("style", "display: inline");
        return autoTransition.spacerElement;
    }

}
