use framework "AppKit"
use framework "WebKit"
use scripting additions

property breakDuration : 20
property breakWindows : {}
property app : missing value
property previousPresentationOptions : 0

on htmlPage()
	return "<!doctype html><html lang='zh-CN'><head><meta charset='utf-8'><style>" & ¬
		"*{box-sizing:border-box;user-select:none;-webkit-user-select:none}html,body{width:100%;height:100%;margin:0;overflow:hidden;background:rgba(0,0,0,.55)}body{color:#fff;font-family:-apple-system,BlinkMacSystemFont,'PingFang SC',sans-serif}.message{position:fixed;left:0;right:0;top:43%;text-align:center;text-shadow:0 2px 18px rgba(0,0,0,.4)}h1{margin:0 0 12px;font-size:38px;letter-spacing:2px}p{margin:0;font-size:20px;opacity:.88;font-variant-numeric:tabular-nums}.track{position:fixed;left:0;right:0;bottom:18%;height:190px}.cat{position:absolute;width:245px;height:185px;animation:walk-across 10s linear infinite,bob .28s ease-in-out infinite alternate}.body{position:absolute;left:28px;bottom:25px;width:166px;height:108px;border:6px solid #2e241f;border-radius:52%;background:#f0923d}.belly{position:absolute;left:68px;bottom:42px;width:92px;height:68px;border-radius:50%;background:#ffdda6}.head{position:absolute;left:132px;bottom:53px;width:108px;height:88px;border:6px solid #2e241f;border-radius:50%;background:#f0923d}.ear{position:absolute;bottom:125px;width:0;height:0;border-left:17px solid transparent;border-right:17px solid transparent;border-bottom:43px solid #2e241f}.ear.left{left:143px;transform:rotate(-8deg)}.ear.right{left:197px;transform:rotate(12deg)}.eye{position:absolute;bottom:103px;width:9px;height:12px;border-radius:50%;background:#2e241f;z-index:3}.eye.left{left:163px}.eye.right{left:204px}.nose{position:absolute;left:184px;bottom:87px;width:11px;height:8px;border-radius:50%;background:#2e241f;z-index:3}.leg{position:absolute;bottom:7px;width:29px;height:47px;border:5px solid #2e241f;border-radius:15px;background:#f0923d;transform-origin:top center}.leg.one{left:65px;animation:step .45s ease-in-out infinite alternate}.leg.two{left:113px;animation:step .45s ease-in-out infinite alternate-reverse}.leg.three{left:159px;animation:step .45s ease-in-out infinite alternate}.tail{position:absolute;left:2px;bottom:77px;width:61px;height:68px;border:13px solid #2e241f;border-right:0;border-bottom:0;border-radius:60px 0 0 0;transform:rotate(-18deg)}.tail:after{content:'';position:absolute;inset:5px -1px -1px 5px;border:7px solid #f0923d;border-right:0;border-bottom:0;border-radius:50px 0 0 0}.whisker{position:absolute;z-index:4;width:35px;height:2px;background:#2e241f;bottom:89px}.w1{left:137px;transform:rotate(8deg)}.w2{left:137px;bottom:80px;transform:rotate(-7deg)}.w3{left:211px;transform:rotate(-8deg)}.w4{left:211px;bottom:80px;transform:rotate(7deg)}@keyframes walk-across{from{left:-260px}to{left:calc(100% + 20px)}}@keyframes bob{from{transform:translateY(0)}to{transform:translateY(-6px)}}@keyframes step{from{transform:rotate(-13deg)}to{transform:rotate(13deg)}}" & ¬
		"</style></head><body><div class='message'><h1>休息一下，看看远处</h1><p>胖猫将在 <strong id='seconds'>20</strong> 秒后让路</p></div><div class='track'><div class='cat'><div class='tail'></div><div class='leg one'></div><div class='leg two'></div><div class='leg three'></div><div class='body'></div><div class='belly'></div><div class='ear left'></div><div class='ear right'></div><div class='head'></div><div class='eye left'></div><div class='eye right'></div><div class='nose'></div><div class='whisker w1'></div><div class='whisker w2'></div><div class='whisker w3'></div><div class='whisker w4'></div></div></div>" & ¬
		"<script>let remaining=20,label=document.getElementById('seconds');setInterval(()=>{remaining=Math.max(0,remaining-1);label.textContent=remaining},1000);addEventListener('keydown',e=>{e.preventDefault();e.stopPropagation()},true);addEventListener('keyup',e=>{e.preventDefault();e.stopPropagation()},true);addEventListener('contextmenu',e=>e.preventDefault());</script></body></html>"
end htmlPage

on createBreakWindow(theScreen)
	set screenFrame to theScreen's frame()
	set theWindow to current application's NSWindow's alloc()'s initWithContentRect:screenFrame styleMask:0 backing:2 defer:false screen:theScreen
	theWindow's setLevel:1000
	theWindow's setOpaque:false
	theWindow's setBackgroundColor:(current application's NSColor's blackColor())
	theWindow's setHasShadow:false
	theWindow's setIgnoresMouseEvents:false
	theWindow's setAcceptsMouseMovedEvents:true
	theWindow's setCollectionBehavior:273
	
	set configuration to current application's WKWebViewConfiguration's alloc()'s init()
	set contentFrame to theWindow's contentView()'s bounds()
	set webView to current application's WKWebView's alloc()'s initWithFrame:contentFrame configuration:configuration
	webView's setAutoresizingMask:18
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
	if app is not missing value then
		try
			app's setPresentationOptions:previousPresentationOptions
		end try
	end if
	set breakWindows to {}
end finishBreak

on run
	my writeLog("应用开始启动（AppleScriptObjC）")
	try
		set breakWindows to {}
		set app to current application's NSApplication's sharedApplication()
		set previousPresentationOptions to app's presentationOptions()
		app's setActivationPolicy:1
		
		set screenList to current application's NSScreen's screens()
		set screenCount to (screenList's |count|()) as integer
		repeat with screenIndex from 0 to (screenCount - 1)
			set theScreen to screenList's objectAtIndex:screenIndex
			my createBreakWindow(theScreen)
		end repeat
		
		app's activateIgnoringOtherApps:true
		try
			-- Hide Dock/menu bar and suppress ordinary app switching while active.
			app's setPresentationOptions:1262
		on error restrictionError
			my writeLog("系统限制未完全启用：" & restrictionError)
		end try
		
		set finishDate to current application's NSDate's dateWithTimeIntervalSinceNow:(breakDuration + 0.2)
		current application's NSRunLoop's currentRunLoop()'s runUntilDate:finishDate
		my writeLog("20 秒休息正常结束")
	on error errorMessage number errorNumber
		my writeLog("启动失败 " & errorNumber & "：" & errorMessage)
		try
			display alert "胖猫休息启动失败" message (errorMessage & return & "请查看 ~/Library/Logs/FatCatBreak.log")
		end try
	end try
	my finishBreak()
end run
