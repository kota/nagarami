package
{
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class HtmlViewer extends HTMLLoader
	{
		private var urls:Array;
		private var scrollTimer:Timer;
		private var loader:URLLoader;
		private var windowHeight:int = 900;
		public function HtmlViewer(seedUrl:String="http://b.hatena.ne.jp/entrylist/it?sort=hot&threshold=&mode=rss")
		{
			this.width = 700;
			this.height = windowHeight;
			
			loader = new URLLoader();
			var req:URLRequest = new URLRequest(seedUrl);
			loader.addEventListener(Event.COMPLETE, onRssLoadComplete);
			loader.load(req);
		}

		private function onRssLoadComplete(event:Event):void
		{
			var RSS:Namespace   = new Namespace("",     "http://purl.org/rss/1.0/");
			var RDF:Namespace   = new Namespace("rdf",  "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
			var xml:XML = new XML(event.target.data);
			urls = new Array();
			for each(var url:XML in xml.RSS::item){
				urls.push(url.@RDF::about);
			}
			
			loadNew();
		}
		
		private function loadNew():void
		{
			var url:String = urls.pop();
			if (url != null)
			{
				this.addEventListener(Event.COMPLETE, scrollHtml);
				var urlReq:URLRequest = new URLRequest(url);
				this.load(urlReq);
			}
		}
		
		private function scrollHtml(event:Event):void
		{
			var maxScrollCount:int = (this.contentHeight - windowHeight) / windowHeight;
			scrollTimer = new Timer(3000, maxScrollCount+2);
			scrollTimer.addEventListener(TimerEvent.TIMER, onTick);
			scrollTimer.addEventListener(TimerEvent.TIMER_COMPLETE,showNext);
			scrollTimer.start();
		}
		
		private function showNext(event:TimerEvent):void
		{
			loadNew();
		}
		
		private function onTick(event:TimerEvent):void
		{
			this.scrollV += windowHeight;
		}

	}
}