({
  // Method for basic confetti mode
    basic : function(component, event, helper){
      confetti({
      particleCount: 200,
      startVelocity: 60,
      spread: 150,
      origin:{
        y: 0.9
          },
        });
    },
    // Method for fireworks confetti mode
    fireworks : function(component, event, helper){
        var end = Date.now() + (15 * 100);
        var interval = setInterval(function() {
        if (Date.now() > end) {
          return clearInterval(interval);
            }
       confetti({
        particleCount : 450,
        startVelocity: 30,
        spread: 360,
        ticks: 60,
        origin:{
          x: Math.random(),
          y: Math.random() 
           },    
          });
        }, 200);
    },
    // Method for shower confetti mode
    shower : function(component, event, helper){
        var end = Date.now() + (15 * 100);
        (function frame() {
        confetti({
         particleCount: 10,
         startVelocity: 0,
         ticks: 300,
         origin: {
         x: Math.random(),
         y: 0
              },
            });
         if (Date.now() < end) {
         requestAnimationFrame(frame);
            }
        }());
    },
    // Method for celebration confetti mode
    celebration : function(component, event, helper) {
        var end = Date.now() + (15 * 100);
        (function frame() {
        confetti({
         particleCount: 10,
         angle: 60,
         spread: 25,
         origin:{
          x: 0,
          y : 0.65
             }, 
            });
        confetti({
         particleCount: 10,
         angle: 120,
         spread: 25,
         origin:{
           x: 1,
           y : 0.65
             },  
            });
        if (Date.now() < end) {
         requestAnimationFrame(frame);
            }
        }());
    },
    // Method for burst confetti mode
    burst : function(component, event, helper){
        var end = Date.now() + (15 * 75);
        //These are four diffrent confetti in frour diffrent corner
        (function frame() {
        // #1
        confetti({
         particleCount: 7,
         startVelocity: 25,
         angle: 335,
         spread: 10,
         origin:{
          x: 0,
          y: 0,
             },
            }); 
         // #2
         confetti({
          particleCount: 7,
          startVelocity: 25,
          angle: 205,
          spread: 10,
          origin:{
            x: 1,
            y: 0,
             },
            });
         // #3
         confetti({
          particleCount: 7,
          startVelocity: 35,
          angle: 140,
          spread: 30,
          origin:{
           x: 1,
           y: 1,
              },
            });
         // #4
         confetti({
          particleCount: 7,
          startVelocity: 35,
          angle: 40,
          spread: 30,
          origin: {
             x: 0,
             y: 1,
                },
            });
            if (Date.now() < end) {
                requestAnimationFrame(frame);
            }
        }());
    }
})