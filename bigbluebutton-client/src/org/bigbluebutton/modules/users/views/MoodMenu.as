/**
 * BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
 *
 * Copyright (c) 2015 BigBlueButton Inc. and by respective authors (see below).
 *
 * This program is free software; you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software
 * Foundation; either version 3.0 of the License, or (at your option) any later
 * version.
 *
 * BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along
 * with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
 *
 */
package org.bigbluebutton.modules.users.views {
	
	import com.asfusion.mate.events.Dispatcher;
	import flash.geom.Point;
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Menu;
	import mx.core.ScrollPolicy;
	import mx.events.FlexMouseEvent;
	import mx.events.MenuEvent;
	import mx.managers.PopUpManager;
	import org.bigbluebutton.common.Images;
	import org.bigbluebutton.core.managers.UserManager;
	import org.bigbluebutton.main.model.users.events.EmojiStatusEvent;
	import org.bigbluebutton.util.i18n.ResourceUtil;
	
	public class MoodMenu extends VBox {
		private const MOODS:Array = ["raiseHand", "agree", "disagree", "speakFaster", "speakSlower",
									"speakLouder", "speakSofter", "beRightBack", "happy", "sad", "clear"];
		
		private var dispatcher:Dispatcher;
		
		private var images:Images;

		private var menu:Menu;
		
		public function MoodMenu() {
			dispatcher = new Dispatcher();
			images = new Images();
			addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseDownOutsideHandler, false, 0, true);
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			drawMoodMenu();
		}

		public function show(position:Point):void {
			menu.x = position.x;
			menu.y = position.y;
			menu.show();
		}
		
		private function drawMoodMenu():void {
			var moods:ArrayCollection = new ArrayCollection();
			for each (var mood:String in MOODS) {
				if (mood == "clear" && UserManager.getInstance().getConference().myEmojiStatus == "none") {
					continue;
				}

				var item:Object = {
					label: ResourceUtil.getInstance().getString('bbb.users.emojiStatus.' + mood),
					icon: images["mood_" + mood]
				};

				moods.addItem(item);
			}
			menu = Menu.createMenu(null, moods.toArray(), true);
			menu.addEventListener(MenuEvent.ITEM_CLICK, buttonMouseEventHandler, false, 0, true);
		}
		
		protected function buttonMouseEventHandler(event:MenuEvent):void {
			var mood:String = MOODS[event.index];
			if (mood == "clear") {
				dispatcher.dispatchEvent(new EmojiStatusEvent(EmojiStatusEvent.EMOJI_STATUS, "none"));
			} else {
				var e:EmojiStatusEvent = new EmojiStatusEvent(EmojiStatusEvent.EMOJI_STATUS, mood);
				dispatcher.dispatchEvent(e);
			}
			hide();
		}
		
		protected function mouseDownOutsideHandler(event:FlexMouseEvent):void {
			hide();
		}
		
		public function hide():void {
			PopUpManager.removePopUp(this);
		}
	}
}