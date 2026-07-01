use framework "AppKit"
use framework "WebKit"
use scripting additions

property breakDuration : 20
property breakWindows : {}
property breakApplication : missing value
property previousPresentationOptions : 0

on htmlPage()
	set durationText to (breakDuration as integer) as text
	set styleBase to "*{box-sizing:border-box;user-select:none;-webkit-user-select:none}html,body{width:100%;height:100%;margin:0;overflow:hidden;background:transparent}body{color:#fff;font-family:-apple-system,BlinkMacSystemFont,'PingFang SC',sans-serif}.message{position:fixed;left:0;right:0;top:39%;text-align:center;text-shadow:0 2px 18px rgba(0,0,0,.8),0 0 4px rgba(0,0,0,.9)}h1{margin:0 0 12px;font-size:38px;letter-spacing:2px}p{margin:0;font-size:20px;opacity:.92;font-variant-numeric:tabular-nums}.track{position:fixed;left:0;right:0;bottom:15%;height:250px}.cat{position:absolute;width:245px;height:185px;left:-280px;bottom:22px}.body{position:absolute;left:28px;bottom:25px;width:166px;height:108px;border:6px solid #2e241f;border-radius:52%;background:#f0923d}.belly{position:absolute;left:68px;bottom:42px;width:92px;height:68px;border-radius:50%;background:#ffdda6}.head{position:absolute;left:132px;bottom:53px;width:108px;height:88px;border:6px solid #2e241f;border-radius:50%;background:#f0923d;transform-origin:45px 70px}.ear{position:absolute;bottom:125px;width:0;height:0;border-left:17px solid transparent;border-right:17px solid transparent;border-bottom:43px solid #2e241f}.ear.left{left:143px;transform:rotate(-8deg)}.ear.right{left:197px;transform:rotate(12deg)}.eye{position:absolute;bottom:103px;width:9px;height:12px;border-radius:50%;background:#2e241f;z-index:3;animation:blink 4.8s infinite}.eye.left{left:163px}.eye.right{left:204px}.nose{position:absolute;left:184px;bottom:87px;width:11px;height:8px;border-radius:50%;background:#2e241f;z-index:3}.leg{position:absolute;bottom:7px;width:29px;height:47px;border:5px solid #2e241f;border-radius:15px;background:#f0923d;transform-origin:top center}.leg.one{left:65px}.leg.two{left:113px}.leg.three{left:159px}.tail{position:absolute;left:2px;bottom:77px;width:61px;height:68px;border:13px solid #2e241f;border-right:0;border-bottom:0;border-radius:60px 0 0 0;transform:rotate(-18deg);transform-origin:62px 68px;animation:tail-sway 1.4s ease-in-out infinite alternate}.tail:after{content:'';position:absolute;inset:5px -1px -1px 5px;border:7px solid #f0923d;border-right:0;border-bottom:0;border-radius:50px 0 0 0}.whisker{position:absolute;z-index:4;width:35px;height:2px;background:#2e241f;bottom:89px}.w1{left:137px;transform:rotate(8deg)}.w2{left:137px;bottom:80px;transform:rotate(-7deg)}.w3{left:211px;transform:rotate(-8deg)}.w4{left:211px;bottom:80px;transform:rotate(7deg)}"
	set propStyle to ".sign{position:absolute;left:120px;bottom:130px;width:120px;height:58px;border:5px solid #2e241f;border-radius:18px;background:#fff4c9;color:#2e241f;text-align:center;font-weight:800;font-size:20px;line-height:48px;opacity:0;transform:rotate(-5deg);box-shadow:0 5px 0 rgba(0,0,0,.15)}.zzz{position:absolute;left:185px;bottom:148px;color:#fff;font-size:24px;font-weight:800;text-shadow:0 2px 10px rgba(0,0,0,.75);opacity:0}.moon{position:absolute;left:50%;top:6%;width:54px;height:54px;border-radius:50%;box-shadow:-14px 8px 0 #fff7bd;opacity:0}.spark{position:absolute;width:12px;height:12px;border-radius:50%;background:#fff7bd;box-shadow:0 0 18px #fff7bd;opacity:0}.cup{position:absolute;left:154px;bottom:15px;width:54px;height:46px;border:5px solid #2e241f;border-top:0;border-radius:0 0 16px 16px;background:#bfe9ff;opacity:0}.cup:after{content:'';position:absolute;right:-22px;top:8px;width:22px;height:22px;border:5px solid #2e241f;border-left:0;border-radius:0 14px 14px 0}.water{position:absolute;left:163px;bottom:51px;width:34px;height:10px;border-radius:50%;background:#6ecbff;opacity:0}.droplet{position:absolute;left:194px;bottom:85px;width:11px;height:15px;border-radius:50% 50% 60% 60%;background:#8edcff;opacity:0}.neckCue{position:absolute;left:138px;bottom:150px;width:110px;height:54px;border-top:5px solid #fff7bd;border-radius:60px 60px 0 0;opacity:0}.neckCue:before,.neckCue:after{content:'';position:absolute;top:-8px;width:14px;height:14px;border-top:5px solid #fff7bd;border-right:5px solid #fff7bd}.neckCue:before{left:3px;transform:rotate(-145deg)}.neckCue:after{right:3px;transform:rotate(35deg)}"
	set sceneStyle to "body.scene-walk .cat{animation:walk-across var(--break-duration) linear forwards,bob .32s ease-in-out infinite alternate}body.scene-walk .leg.one,body.scene-walk .leg.three{animation:step .45s ease-in-out infinite alternate}body.scene-walk .leg.two{animation:step .45s ease-in-out infinite alternate-reverse}body.scene-nap .cat{left:50%;margin-left:-122px;animation:nap-pose var(--break-duration) ease-in-out forwards}body.scene-nap .head{animation:nod 3.2s ease-in-out infinite}body.scene-nap .zzz{animation:float-zzz 3.4s ease-in-out infinite}body.scene-nap .moon{animation:moon-in var(--break-duration) ease-in-out forwards}body.scene-sign .cat{left:50%;margin-left:-122px;animation:sign-bounce var(--break-duration) ease-in-out forwards}body.scene-sign .sign{animation:show-sign var(--break-duration) ease-in-out forwards}body.scene-drink .cat{left:50%;margin-left:-122px;animation:sign-bounce var(--break-duration) ease-in-out forwards}body.scene-drink .head{animation:sip 2.4s ease-in-out infinite}body.scene-drink .cup,body.scene-drink .water{animation:prop-in var(--break-duration) ease-in-out forwards}body.scene-drink .droplet{animation:drop 1.8s ease-in-out infinite}body.scene-neck .cat{left:50%;margin-left:-122px;animation:sign-bounce var(--break-duration) ease-in-out forwards}body.scene-neck .head{animation:neck-turn 3.8s ease-in-out infinite}body.scene-neck .neckCue{animation:cue-in var(--break-duration) ease-in-out forwards}body.scene-sign .spark.one,body.scene-neck .spark.one{left:35%;top:24%;animation:sparkle 2.6s .5s infinite}body.scene-sign .spark.two,body.scene-neck .spark.two{right:32%;top:30%;animation:sparkle 2.2s 1.1s infinite}body.scene-sign .spark.three,body.scene-neck .spark.three{left:58%;top:20%;animation:sparkle 3s 1.7s infinite}"
	set keyframesStyle to "@keyframes walk-across{0%{left:-280px;opacity:0}8%{opacity:1}90%{opacity:1}100%{left:calc(100% + 20px);opacity:0}}@keyframes bob{from{bottom:22px}to{bottom:29px}}@keyframes step{from{transform:rotate(-13deg)}to{transform:rotate(13deg)}}@keyframes tail-sway{from{transform:rotate(-24deg)}to{transform:rotate(-8deg)}}@keyframes blink{0%,92%,100%{transform:scaleY(1)}95%{transform:scaleY(.12)}}@keyframes nap-pose{0%{opacity:0;bottom:18px;transform:translateX(-45vw) rotate(0)}18%{opacity:1;bottom:25px;transform:translateX(0) rotate(0)}32%,100%{opacity:1;bottom:0;transform:translateX(0) rotate(-4deg)}}@keyframes nod{0%,100%{transform:rotate(0)}50%{transform:rotate(6deg)}}@keyframes float-zzz{0%{opacity:0;transform:translateY(18px) scale(.8)}30%,70%{opacity:1}100%{opacity:0;transform:translateY(-42px) scale(1.25)}}@keyframes moon-in{0%,18%{opacity:0;transform:translateY(-10px)}30%,100%{opacity:.88;transform:translateY(0)}}@keyframes sign-bounce{0%{opacity:0;bottom:12px;transform:scale(.92)}12%{opacity:1;bottom:28px;transform:scale(1.02)}20%,100%{opacity:1;bottom:22px;transform:scale(1)}}@keyframes show-sign{0%,18%{opacity:0;transform:translateY(20px) rotate(-12deg)}28%,86%{opacity:1;transform:translateY(0) rotate(-5deg)}100%{opacity:0;transform:translateY(-10px) rotate(4deg)}}@keyframes sparkle{0%,100%{opacity:0;transform:scale(.4)}45%{opacity:1;transform:scale(1.25)}}@keyframes prop-in{0%,16%{opacity:0;transform:translateY(12px)}24%,92%{opacity:1;transform:translateY(0)}100%{opacity:0;transform:translateY(12px)}}@keyframes sip{0%,100%{transform:rotate(0) translateY(0)}45%,58%{transform:rotate(10deg) translateY(10px)}}@keyframes drop{0%,100%{opacity:0;transform:translateY(-12px)}35%{opacity:1}70%{opacity:0;transform:translateY(18px)}}@keyframes neck-turn{0%,100%{transform:rotate(0)}25%{transform:rotate(-16deg)}50%{transform:rotate(0)}75%{transform:rotate(16deg)}}@keyframes cue-in{0%,12%{opacity:0;transform:translateY(10px)}22%,90%{opacity:.86;transform:translateY(0)}100%{opacity:0;transform:translateY(-6px)}}"
	set bodyHtml to "</style></head><body style='--break-duration:" & durationText & "s'><div class='message'><h1 id='title'>休息一下，看看远处</h1><p><span id='subtitle'>胖猫正在巡逻</span>，<strong id='seconds'>" & durationText & "</strong> 秒后让路</p></div><div class='moon'></div><div class='spark one'></div><div class='spark two'></div><div class='spark three'></div><div class='track'><div class='cat'><div class='sign'>休息啦</div><div class='zzz'>Z z z</div><div class='neckCue'></div><div class='droplet'></div><div class='water'></div><div class='cup'></div><div class='tail'></div><div class='leg one'></div><div class='leg two'></div><div class='leg three'></div><div class='body'></div><div class='belly'></div><div class='ear left'></div><div class='ear right'></div><div class='head'></div><div class='eye left'></div><div class='eye right'></div><div class='nose'></div><div class='whisker w1'></div><div class='whisker w2'></div><div class='whisker w3'></div><div class='whisker w4'></div></div></div>"
	set scriptHtml to "<script>let scenes=[['scene-walk','休息一下，看看远处','胖猫正在巡逻'],['scene-nap','和胖猫一起打个盹','胖猫已经趴好'],['scene-sign','胖猫举牌提醒你','现在离开屏幕'],['scene-drink','喝口水，放松一下','胖猫也在补水'],['scene-neck','转转脖子，松一松','跟胖猫慢慢活动']];let picked=scenes[Math.floor(Math.random()*scenes.length)];document.body.className=picked[0];document.getElementById('title').textContent=picked[1];document.getElementById('subtitle').textContent=picked[2];let remaining=" & durationText & ",label=document.getElementById('seconds');setInterval(()=>{remaining=Math.max(0,remaining-1);label.textContent=remaining},1000);addEventListener('keydown',e=>{e.preventDefault();e.stopPropagation()},true);addEventListener('keyup',e=>{e.preventDefault();e.stopPropagation()},true);addEventListener('contextmenu',e=>e.preventDefault());</script></body></html>"
	return "<!doctype html><html lang='zh-CN'><head><meta charset='utf-8'><style>" & styleBase & propStyle & sceneStyle & keyframesStyle & bodyHtml & scriptHtml
end htmlPage

on createBreakWindow(theScreen)
	set screenFrame to theScreen's frame()
	set windowClass to current application's NSWindow
	set windowAllocation to windowClass's alloc()
	set theWindow to windowAllocation's initWithContentRect:screenFrame styleMask:0 backing:2 defer:false screen:theScreen
	theWindow's setLevel:1000
	theWindow's setOpaque:false
	set colorClass to current application's NSColor
	set clearColor to colorClass's clearColor()
	theWindow's setBackgroundColor:clearColor
	theWindow's setHasShadow:false
	theWindow's setIgnoresMouseEvents:false
	theWindow's setAcceptsMouseMovedEvents:true
	theWindow's setCollectionBehavior:273
	
	set configurationClass to current application's WKWebViewConfiguration
	set configurationAllocation to configurationClass's alloc()
	set configuration to configurationAllocation's init()
	set contentView to theWindow's contentView()
	-- `bounds` is an AppleScript terminology keyword on older releases. Using
	-- the content view's frame avoids the parser treating bounds() as a property.
	set contentFrame to contentView's frame()
	set webViewClass to current application's WKWebView
	set webViewAllocation to webViewClass's alloc()
	set webView to webViewAllocation's initWithFrame:contentFrame configuration:configuration
	webView's setAutoresizingMask:18
	try
		webView's setUnderPageBackgroundColor:clearColor
	end try
	try
		webView's setValue:(false) forKey:("drawsBackground")
	end try
	webView's loadHTMLString:(my htmlPage()) baseURL:(missing value)
	theWindow's setContentView:webView
	theWindow's makeKeyAndOrderFront:(missing value)
	set end of breakWindows to theWindow
end createBreakWindow

on writeLog(messageText)
	try
		set logPath to POSIX path of (path to library folder from user domain) & "Logs/FatCatBreak.log"
		do shell script "/bin/mkdir -p " & quoted form of ((POSIX path of (path to library folder from user domain)) & "Logs") & "; /bin/date '+%Y-%m-%d %H:%M:%S %z' >> " & quoted form of logPath & "; /bin/echo " & quoted form of (messageText as text) & " >> " & quoted form of logPath
	end try
end writeLog

on finishBreak()
	repeat with theWindow in breakWindows
		try
			theWindow's orderOut:(missing value)
		end try
	end repeat
	if breakApplication is not missing value then
		try
			breakApplication's setPresentationOptions:previousPresentationOptions
		end try
	end if
	set breakWindows to {}
end finishBreak

on run
	my writeLog("应用开始启动（AppleScriptObjC）")
	try
		set breakWindows to {}
		set applicationClass to current application's NSApplication
		-- `app` is an alias for AppleScript's read-only `application` term on some
		-- older releases, so keep the NSApplication instance under a distinct name.
		set breakApplication to applicationClass's sharedApplication()
		set previousPresentationOptions to breakApplication's presentationOptions()
		breakApplication's setActivationPolicy:1
		
		set screenClass to current application's NSScreen
		set screenList to screenClass's screens()
		set screenCount to (screenList's |count|()) as integer
		repeat with screenIndex from 0 to (screenCount - 1)
			set theScreen to screenList's objectAtIndex:screenIndex
			my createBreakWindow(theScreen)
		end repeat
		
		breakApplication's activateIgnoringOtherApps:true
		try
			-- Hide Dock/menu bar and suppress ordinary app switching while active.
			breakApplication's setPresentationOptions:1262
		on error restrictionError
			my writeLog("系统限制未完全启用：" & restrictionError)
		end try
		
		set dateClass to current application's NSDate
		set finishDate to dateClass's dateWithTimeIntervalSinceNow:(breakDuration + 0.2)
		set runLoopClass to current application's NSRunLoop
		set currentRunLoop to runLoopClass's currentRunLoop()
		currentRunLoop's runUntilDate:finishDate
		my writeLog("20 秒休息正常结束")
	on error errorMessage number errorNumber
		my writeLog("启动失败 " & errorNumber & "：" & errorMessage)
		try
			display alert "胖猫休息启动失败" message (errorMessage & return & "请查看 ~/Library/Logs/FatCatBreak.log")
		end try
	end try
	my finishBreak()
end run
