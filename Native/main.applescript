use framework "AppKit"
use framework "WebKit"
use framework "CoreGraphics"

property breakDuration : 30
property breakWindows : {}
property breakApplication : missing value
property previousPresentationOptions : 0
property nextBreakDate : missing value
property breakEndDate : missing value
property breakIsActive : false
property settingsWindow : missing value
property intervalField : missing value
property durationField : missing value
property loginCheckbox : missing value
property loginHitView : missing value
property takeBreakButton : missing value
property applyButton : missing value
property quitButton : missing value
property mouseWasDown : false

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
	-- WKWebView otherwise paints its own white under-page background. Tahoe
	-- supports underPageBackgroundColor; drawsBackground keeps older macOS
	-- releases transparent as well.
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

on append_to_log(log_entry)
	try
		current application's NSLog_("%@", log_entry as text)
	end try
end append_to_log

on defaults_store()
	set d1 to current application's NSUserDefaults
	return d1's standardUserDefaults()
end defaults_store

on interval_hours()
	set d1 to my defaults_store()
	set h1 to (d1's doubleForKey:"TriggerIntervalHours") as real
	if h1 < 0.1 then
		set h1 to 2
		d1's setDouble:h1 forKey:"TriggerIntervalHours"
	end if
	return h1
end interval_hours

on schedule_next_break()
	set s1 to (my interval_hours()) * 3600
	set d1 to current application's NSDate
	set nextBreakDate to d1's dateWithTimeIntervalSinceNow:s1
	my append_to_log("下次休息将在 " & (my interval_hours()) & " 小时后触发")
end schedule_next_break

on apply_interval(h1)
	if h1 < 0.1 then set h1 to 0.1
	if h1 > 168 then set h1 to 168
	set d1 to my defaults_store()
	d1's setDouble:h1 forKey:"TriggerIntervalHours"
	d1's synchronize()
	my schedule_next_break()
end apply_interval

on duration_seconds()
	set d1 to my defaults_store()
	set existing1 to d1's objectForKey:"BreakDurationSeconds"
	if existing1 is missing value then
		set s1 to 30
		d1's setDouble:s1 forKey:"BreakDurationSeconds"
		return s1
	end if
	set s1 to (d1's doubleForKey:"BreakDurationSeconds") as real
	if s1 < 1 then
		set s1 to 1
		d1's setDouble:s1 forKey:"BreakDurationSeconds"
	end if
	if s1 > 600 then
		set s1 to 600
		d1's setDouble:s1 forKey:"BreakDurationSeconds"
	end if
	return s1
end duration_seconds

on apply_duration(s1)
	if s1 < 1 then set s1 to 1
	if s1 > 600 then set s1 to 600
	set d1 to my defaults_store()
	d1's setDouble:s1 forKey:"BreakDurationSeconds"
	d1's synchronize()
	set breakDuration to s1
end apply_duration

on login_agent_path()
	set p1 to current application's NSHomeDirectory() as text
	return p1 & "/Library/LaunchAgents/com.hellocodex.fatcatbreak.plist"
end login_agent_path

on login_item_enabled()
	set f1 to current application's NSFileManager
	set f2 to f1's defaultManager()
	return (f2's fileExistsAtPath:(my login_agent_path())) as boolean
end login_item_enabled

on enable_login_item()
	set f1 to current application's NSFileManager
	set f2 to f1's defaultManager()
	set p1 to current application's NSHomeDirectory() as text
	set p2 to p1 & "/Library/LaunchAgents"
	f2's createDirectoryAtPath:p2 withIntermediateDirectories:true attributes:(missing value) |error|:(missing value)

	set b1 to current application's NSBundle
	set b2 to b1's mainBundle()
	set b3 to b2's bundlePath() as text
	set a1 to current application's NSMutableArray
	set a2 to a1's array()
	a2's addObject:"/usr/bin/open"
	a2's addObject:b3

	set d1 to current application's NSMutableDictionary
	set d2 to d1's dictionary()
	d2's setObject:"com.hellocodex.fatcatbreak" forKey:"Label"
	d2's setObject:a2 forKey:"ProgramArguments"
	d2's setObject:true forKey:"RunAtLoad"
	return (d2's writeToFile:(my login_agent_path()) atomically:true) as boolean
end enable_login_item

on disable_login_item()
	set f1 to current application's NSFileManager
	set f2 to f1's defaultManager()
	if f2's fileExistsAtPath:(my login_agent_path()) then
		f2's removeItemAtPath:(my login_agent_path()) |error|:(missing value)
	end if
end disable_login_item

on set_login_item(enabled1)
	if enabled1 then
		if not (my login_item_enabled()) then my enable_login_item()
	else
		if my login_item_enabled() then my disable_login_item()
	end if
end set_login_item

on make_label(t1, r1, size1)
	set c1 to current application's NSTextField
	set v1 to c1's alloc()
	set v2 to v1's initWithFrame:r1
	v2's setStringValue:t1
	v2's setBezeled:false
	v2's setDrawsBackground:false
	v2's setEditable:false
	v2's setSelectable:false
	set f1 to current application's NSFont
	v2's setFont:(f1's systemFontOfSize:size1)
	return v2
end make_label

on make_button(t1, r1)
	set c1 to current application's NSButton
	set b1 to c1's alloc()
	set b2 to b1's initWithFrame:r1
	b2's setTitle:t1
	b2's setButtonType:0
	b2's setBezelStyle:1
	return b2
end make_button

on build_settings_window()
	set w1 to current application's NSWindow
	set settingsWindow to w1's alloc()
	set settingsWindow to settingsWindow's initWithContentRect:{{0, 0}, {460, 310}} styleMask:15 backing:2 defer:false
	settingsWindow's setTitle:"FatCatBreak Settings"
	settingsWindow's performSelector:("center")
	set v1 to settingsWindow's contentView()

	v1's addSubview:(my make_label("FatCatBreak", {{28, 255}, {400, 34}}, 24))
	v1's addSubview:(my make_label("FatCat appears after the configured number of hours.", {{28, 224}, {400, 24}}, 13))
	v1's addSubview:(my make_label("Trigger interval:", {{28, 180}, {120, 24}}, 14))

	set t1 to current application's NSTextField
	set intervalField to t1's alloc()
	set intervalField to intervalField's initWithFrame:{{150, 176}, {72, 30}}
	intervalField's setDoubleValue:(my interval_hours())
	intervalField's setAlignment:2
	v1's addSubview:intervalField
	v1's addSubview:(my make_label("hours (0.1–168)", {{232, 180}, {160, 24}}, 14))

	v1's addSubview:(my make_label("Stay duration:", {{28, 136}, {120, 24}}, 14))
	set t2 to current application's NSTextField
	set durationField to t2's alloc()
	set durationField to durationField's initWithFrame:{{150, 132}, {72, 30}}
	durationField's setDoubleValue:(my duration_seconds())
	durationField's setAlignment:2
	v1's addSubview:durationField
	v1's addSubview:(my make_label("seconds (1–600)", {{232, 136}, {160, 24}}, 14))

	set c1 to current application's NSButton
	set loginCheckbox to c1's alloc()
	set loginCheckbox to loginCheckbox's initWithFrame:{{28, 92}, {240, 28}}
	loginCheckbox's setButtonType:3
	loginCheckbox's setTitle:"Launch FatCatBreak at login"
	loginCheckbox's setState:(my login_item_enabled() as integer)
	v1's addSubview:loginCheckbox
	set h1 to current application's NSView
	set loginHitView to h1's alloc()
	set loginHitView to loginHitView's initWithFrame:{{28, 92}, {240, 28}}
	v1's addSubview:loginHitView

	set takeBreakButton to my make_button("Take Break Now", {{28, 28}, {130, 34}})
	v1's addSubview:takeBreakButton
	set quitButton to my make_button("Quit", {{282, 28}, {70, 34}})
	v1's addSubview:quitButton
	set applyButton to my make_button("Apply", {{362, 28}, {70, 34}})
	v1's addSubview:applyButton
end build_settings_window

on apply_settings()
	set h1 to (intervalField's doubleValue()) as real
	if h1 < 0.1 then set h1 to 0.1
	if h1 > 168 then set h1 to 168
	intervalField's setDoubleValue:h1
	my apply_interval(h1)
	set s1 to (durationField's doubleValue()) as real
	if s1 < 1 then set s1 to 1
	if s1 > 600 then set s1 to 600
	durationField's setDoubleValue:s1
	my apply_duration(s1)
	my set_login_item(((loginCheckbox's state()) as integer) is 1)
	if settingsWindow is not missing value then settingsWindow's orderOut:(missing value)
end apply_settings

on show_settings()
	if settingsWindow is missing value then my build_settings_window()
	intervalField's setDoubleValue:(my interval_hours())
	durationField's setDoubleValue:(my duration_seconds())
	loginCheckbox's setState:(my login_item_enabled() as integer)
	settingsWindow's makeKeyAndOrderFront:(missing value)
	breakApplication's activateIgnoringOtherApps:true
end show_settings

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
	set breakEndDate to missing value
end finishBreak

on start_break()
	if breakIsActive then return
	set breakIsActive to true
	set breakDuration to my duration_seconds()

	my append_to_log((breakDuration as text) & " 秒休息开始")
	try
		set breakWindows to {}
		set previousPresentationOptions to breakApplication's presentationOptions()
		if settingsWindow is not missing value then settingsWindow's orderOut:(missing value)

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
			my append_to_log("系统限制未完全启用：" & restrictionError)
		end try

		set dateClass to current application's NSDate
		set breakEndDate to dateClass's dateWithTimeIntervalSinceNow:breakDuration
	on error xerr number xnum
		set q1 to "启动失败 " & (xnum as text) & "：" & (xerr as text)
		my append_to_log(q1)
		try
			set a1 to current application's NSAlert
			set a2 to a1's alloc()
			set a3 to a2's init()
			a3's setMessageText:"胖猫休息启动失败"
			a3's setInformativeText:((xerr as text) & return & "请运行 scripts/run_debug.sh 查看错误")
			a3's runModal()
		end try
		my finishBreak()
		set breakIsActive to false
		my schedule_next_break()
	end try
end start_break

on complete_break()
	my append_to_log((breakDuration as text) & " 秒休息正常结束")
	my finishBreak()
	set breakIsActive to false
	my schedule_next_break()
end complete_break

on escape_is_down()
	return (current application's CGEventSourceKeyState(0, 53)) as boolean
end escape_is_down

on mouse_is_over(b1)
	if settingsWindow is missing value then return false
	if not (settingsWindow's isVisible() as boolean) then return false
	set r1 to b1's frame()
	set r2 to settingsWindow's convertRectToScreen:r1
	set e1 to current application's NSEvent
	set p1 to e1's mouseLocation()
	return (current application's NSMouseInRect(p1, r2, false)) as boolean
end mouse_is_over

on quit_application()
	my finishBreak()
	breakApplication's terminate:(missing value)
end quit_application

on run
	my append_to_log("应用开始启动（AppleScriptObjC）")
	set applicationClass to current application's NSApplication
	-- `app` is an alias for AppleScript's read-only `application` term on some
	-- releases, so keep the NSApplication instance under a distinct name.
	set breakApplication to applicationClass's sharedApplication()
	breakApplication's setActivationPolicy:0

	my schedule_next_break()
end run

on reopen
	my show_settings()
end reopen

on idle
	if breakIsActive then
		if my escape_is_down() then
			my append_to_log("ESC pressed; quitting FatCatBreak")
			my quit_application()
			return 1
		end if
		if breakEndDate is not missing value then
			if ((breakEndDate's timeIntervalSinceNow()) as real) ≤ 0 then my complete_break()
		end if
		return 0.05
	end if

	set mouseIsDown to (current application's CGEventSourceButtonState(0, 0)) as boolean
	if mouseIsDown and not mouseWasDown then
		if my mouse_is_over(loginHitView) then
			set loginEnabled to not (my login_item_enabled())
			loginCheckbox's setState:(loginEnabled as integer)
			my set_login_item(loginEnabled)
			my append_to_log("Launch at login changed to " & loginEnabled)
			set mouseWasDown to true
			return 0.05
		else if my mouse_is_over(quitButton) then
			set mouseWasDown to true
			my quit_application()
			return 1
		else if my mouse_is_over(applyButton) then
			my apply_settings()
		else if my mouse_is_over(takeBreakButton) then
			my append_to_log("Take Break Now clicked")
			my start_break()
			set mouseWasDown to true
			return 0.05
		end if
	end if
	set mouseWasDown to mouseIsDown

	if nextBreakDate is not missing value then
		if ((nextBreakDate's timeIntervalSinceNow()) as real) ≤ 0 then
			my start_break()
		end if
	end if
	return 0.2
end idle
