(function() {
  /* Mob client-side code */  $(function() {
    return window.Mob = (function() {
      function Mob(data) {
        this.moveConst = 0.825;
        this.uid = data.uid, this.x = data.x, this.y = data.y, this.dx = data.dx, this.dy = data.dy, this.speed = data.speed, this.maxHP = data.maxHP, this.curHP = data.curHP, this.symbol = data.symbol;
      }
      Mob.prototype.move = function(mobdata) {
        return this.x = mobdata.x, this.y = mobdata.y, this.dx = mobdata.dx, this.dy = mobdata.dy, this.speed = mobdata.speed, mobdata;
      };
      Mob.prototype.update = function() {
        this.x = this.x + (this.dx * this.speed * this.moveConst / FPS);
        return this.y = this.y + (this.dy * this.speed * this.moveConst / FPS);
      };
      Mob.prototype.draw = function(context) {
        var x, y;
        context.fillStyle = '#000';
        x = this.getLoc(this.x);
        y = this.getLoc(this.y);
        context.font = '40pt Pictos';
        return context.fillText(this.symbol, x + 2, y - 10);
      };
      Mob.prototype.pause = function() {
        console.log('paused!');
        this.dx = 0;
        return this.dy = 0;
      };
      Mob.prototype.getLoc = function(loc) {
        return loc * squarewidth;
      };
      return Mob;
    })();
  });
}).call(this);
