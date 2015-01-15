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

sendBomb = (msg, body) ->
  body = JSON.parse(body)
  for i in [0...body.data.length] by (body.data.length / 20)
    sendPost(msg, body.data[i])
    
  

sendRandomPost = (msg, body) ->
  body = JSON.parse(body)
  thePost = body.data[Math.floor(Math.random()*body.data.length)]
  sendPost(msg, thePost)

sendPost = (msg, thePost) ->
  if(!thePost) then return msg.send 'No lols found on imgur ◖㈠ ω ㈠◗'
  if(thePost.nsfw) then return msg.send 'Image was flagged NSFW ◖㈠ ω ㈠◗'
  if typeof thePost.title is 'string' then msg.send thePost.title
  msg.send thePost.link
  if typeof thePost.description is 'string' then msg.send thePost.description


module.exports = (robot) ->

  robot.hear /front page/i, (msg) ->
    console.log('heard message: front page')
    baseOptions.url = 'https://api.imgur.com/3/gallery/hot/viral/0.json'
    request.get baseOptions, (err, res, body) ->
      sendRandomPost(msg, body);


  robot.hear /(.*) bomb/i, (msg) ->
    console.log "Heard message #{msg.match} bomb"
    baseOptions.url = "https://api.imgur.com/3/gallery/search/top/?q_exactly=#{msg.match}"
    request.get baseOptions, (err, res, body) ->
      sendBomb(msg, body);
