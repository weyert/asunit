﻿package asunit4.printers {
	import asunit.errors.AssertionFailedError;
	import asunit.framework.ITestFailure;
	import asunit4.framework.IFreeTestResult;
	import asunit4.events.TestResultEvent;
	import com.bit101.components.*;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.system.Capabilities;

	public class MinimalPrinter extends Sprite implements IResultPrinter {
		protected static const localPathPattern:RegExp = /([A-Z]:\\[^\/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^\/:\*\?<>\|]+\.\w{2,6})/g;

		private var failuresField:Text;
		private var times:Text;
		private var header:Text;
		private var dots:Text;
		private var backgroundFill:Shape;

		public function MinimalPrinter() {
			if (stage)
				initUI();
			else
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function startTestRun():void {
		}
		
		public function addTestResult(result:IFreeTestResult):void {
			dots.text += '.';
			
			var failures:Array = result.errors.concat(result.failures);
			//var failures:Array = result.failures;
			var s:String = '';
			var stack:String = '';
			for each (var failure:ITestFailure in failures) {
				s += getQualifiedClassName(failure.failedTest);
				s += '.' + failure.failedMethod + ' : ';
				
				//if (failure.thrownException['constructor'] != AssertionFailedError) {
					//s += getQualifiedClassName(failure.thrownException);
				//}
				
				//s += failure.exceptionMessage + '\n';
				stack = failure.thrownException.getStackTrace();
				
				stack = stack.replace(localPathPattern, '');
				stack = stack.replace(/AssertionFailedError: /, '');

				s += stack + '\n\n';
			}
			failuresField.text += s;
			
		}
		
		public function endTestRun():void {
		}
		
		protected function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onStageResize);
			initUI();
		}
		
		protected function onStageResize(e:Event):void {
			failuresField.width = stage.stageWidth;
			backgroundFill.width = stage.stageWidth;
			backgroundFill.height = stage.stageHeight;
		}
		
		protected function initUI():void {
			backgroundFill = new Shape();
			backgroundFill.graphics.beginFill(0x333333);
			backgroundFill.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			addChild(backgroundFill);
			
			Style.LABEL_TEXT = 0xFFFFFF;
			
			var vbox:VBox = new VBox(this);
			vbox.spacing = 0;
			
			header = new Text(vbox);
			header.width = 400;
			header.height = 50;
			header.editable = false;
			header.text = "AsUnit 3.0 by Luke Bayes and Ali Mills"
				+ "\n\n" + "Flash Player version: " + Capabilities.version

			dots = new Text(vbox);
			dots.width = 800;
			dots.height = 20;

			failuresField = new Text(vbox);
			failuresField.width = stage.stageWidth;
			failuresField.height = 300;
			failuresField.editable = false;
			
			times = new Text(vbox);
			times.width = 400;
			times.height = 200;
			times.editable = false;
		}
		
	}
}
