# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://g ithub.com/github/hubot/blob/master/docs/scripting.md
request = require('request');

baseOptions = {
      headers: {
        'Authorization': 'Client-ID ' + process.env.IMGUR_CLIENT_ID
      }
    }

module.exports = (robot) ->

  robot.hear /front page/i, (msg) ->
    console.log('heard message: front page')
    baseOptions.url = 'https://api.imgur.com/3/gallery/hot/viral/0.json'
    request.get(baseOptions, (err, res, body) ->
      body = JSON.parse(body)
      thePost = body.data[Math.floor(Math.random()*body.data.length)]
      if typeof thePost.title === 'string' then msg.send thePost.title
      msg.send thePost.link
      if typeof thePost.description === 'string' then msg.send thePost.description
      );
