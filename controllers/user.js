(function() {
  var User, Users, cfg, db, mongoose;
  mongoose = require('mongoose');
  cfg = require('../config/config.js');
  db = mongoose.connect(cfg.DB);
  User = require('../models/user-model.js');
  exports.Users = Users = (function() {
    function Users() {}
    Users.prototype.get = function(id, callback) {
      var query;
      query = {};
      if (id !== null) {
        query = {
          'id': id
        };
      }
      return User.find(query, function(err, user) {
        if (err) {
          return logger.error('Error Retrieving: ' + err);
        } else {
          return callback(user);
        }
      });
    };
    Users.prototype.addUser = function(id, name, callback) {
      var newuser;
      newuser = new User({
        'id': id,
        'name': name
      });
      return newuser.save(function(err, user_saved) {
        if (err) {
          return logger.warn('Error Saving: ' + err);
        } else {
          return logger.info('Saved: ' + newuser);
        }
      });
    };
    return Users;
  })();
}).call(this);
