# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://g ithub.com/github/hubot/blob/master/docs/scripting.md
request = require 'request'
async = require 'async'

baseOptions = {
      headers: {
        'Authorization': 'Client-ID ' + process.env.IMGUR_CLIENT_ID
      }
    }

sendBomb = (msg, body) ->
  body = JSON.parse(body)
  queue = []
  if(body and body.data and body.data.length)
    for i in [0...20]
      if(body.data[i])
        queue.push sendPost(msg, body.data[i])
    async.series(queue);
  else
    msg.send 'No lols found on imgur ◖㈠ ω ㈠◗'
    
  

sendRandomPost = (msg, body) ->
  body = JSON.parse(body)
  thePost = body.data[Math.floor(Math.random()*body.data.length)]
  sendPost(msg, thePost)


sendPost = (msg, thePost, cb_) ->
  setTimeout (->
    if(!thePost) then return msg.send 'No lols found on imgur ◖㈠ ω ㈠◗'
    if(thePost.nsfw) then return msg.send 'Image was flagged NSFW ◖㈠ ω ㈠◗'
    if typeof thePost.title is 'string' then msg.send thePost.title
    msg.send thePost.link
    if typeof thePost.description is 'string' then msg.send thePost.description
    if(cb_ ) then cb_()
    ), 1100


module.exports = (robot) ->

  robot.hear /front page/i, (msg) ->
    console.log('heard message: front page')
    baseOptions.url = 'https://api.imgur.com/3/gallery/hot/viral/0.json'
    request.get baseOptions, (err, res, body) ->
      sendRandomPost(msg, body);


  robot.respond /(.*) bomb/i, (msg) ->
    console.log "Heard message #{msg.match[1]} bomb"
    baseOptions.url = "https://api.imgur.com/3/gallery/search/top/?q_exactly=#{msg.match[1]}"
    request.get baseOptions, (err, res, body) ->
      sendBomb(msg, body);
