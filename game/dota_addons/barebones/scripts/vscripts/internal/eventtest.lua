function GameMode:StartEventTest()
	ListenToGameEvent("team_info", Dynamic_Wrap(GameMode, 'On_team_info'), self)
	ListenToGameEvent("team_score", Dynamic_Wrap(GameMode, 'On_team_score'), self)
	ListenToGameEvent("teamplay_broadcast_audio", Dynamic_Wrap(GameMode, 'On_teamplay_broadcast_audio'), self)
	ListenToGameEvent("player_team", Dynamic_Wrap(GameMode, 'On_player_team'), self)
	ListenToGameEvent("player_class", Dynamic_Wrap(GameMode, 'On_player_class'), self)
	ListenToGameEvent("player_death", Dynamic_Wrap(GameMode, 'On_player_death '), self)
	ListenToGameEvent("player_hurt", Dynamic_Wrap(GameMode, 'On_player_hurt '), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'On_player_chat '), self)
	ListenToGameEvent("player_score", Dynamic_Wrap(GameMode, 'On_player_score'), self)
	ListenToGameEvent("player_spawn", Dynamic_Wrap(GameMode, 'On_player_spawn'), self)
	ListenToGameEvent("player_shoot", Dynamic_Wrap(GameMode, 'On_player_shoot'), self)
	ListenToGameEvent("player_use", Dynamic_Wrap(GameMode, 'On_player_use'), self)
	ListenToGameEvent("player_changename", Dynamic_Wrap(GameMode, 'On_player_changename'), self)
	ListenToGameEvent("player_hintmessage", Dynamic_Wrap(GameMode, 'On_player_hintmessage'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'On_player_reconnected '), self)
	ListenToGameEvent("game_init", Dynamic_Wrap(GameMode, 'On_game_init'), self)
	ListenToGameEvent("game_newmap", Dynamic_Wrap(GameMode, 'On_game_newmap'), self)
	ListenToGameEvent("game_start", Dynamic_Wrap(GameMode, 'On_game_start'), self)
	ListenToGameEvent("game_end", Dynamic_Wrap(GameMode, 'On_game_end'), self)
	ListenToGameEvent("round_start", Dynamic_Wrap(GameMode, 'On_round_start'), self)
	ListenToGameEvent("round_end", Dynamic_Wrap(GameMode, 'On_round_end'), self)
	ListenToGameEvent("round_start_pre_entity", Dynamic_Wrap(GameMode, 'On_round_start_pre_entity'), self)
	ListenToGameEvent("teamplay_round_start", Dynamic_Wrap(GameMode, 'On_teamplay_round_start'), self)
	ListenToGameEvent("hostname_changed", Dynamic_Wrap(GameMode, 'On_hostname_changed'), self)
	ListenToGameEvent("difficulty_changed", Dynamic_Wrap(GameMode, 'On_difficulty_changed'), self)
	ListenToGameEvent("finale_start", Dynamic_Wrap(GameMode, 'On_finale_start'), self)
	ListenToGameEvent("game_message", Dynamic_Wrap(GameMode, 'On_game_message'), self)
	ListenToGameEvent("break_breakable", Dynamic_Wrap(GameMode, 'On_break_breakable'), self)
	ListenToGameEvent("break_prop", Dynamic_Wrap(GameMode, 'On_break_prop'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(GameMode, 'On_npc_spawned'), self)
	ListenToGameEvent("npc_replaced", Dynamic_Wrap(GameMode, 'On_npc_replaced'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(GameMode, 'On_entity_killed'), self)
	--ListenToGameEvent("entity_hurt", Dynamic_Wrap(GameMode, 'On_entity_hurt'), self)
	ListenToGameEvent("bonus_updated", Dynamic_Wrap(GameMode, 'On_bonus_updated'), self)
	ListenToGameEvent("player_stats_updated", Dynamic_Wrap(GameMode, 'On_player_stats_updated'), self)
	ListenToGameEvent("achievement_event", Dynamic_Wrap(GameMode, 'On_achievement_event'), self)
	ListenToGameEvent("achievement_earned", Dynamic_Wrap(GameMode, 'On_achievement_earned'), self)
	ListenToGameEvent("achievement_write_failed", Dynamic_Wrap(GameMode, 'On_achievement_write_failed'), self)
	ListenToGameEvent("physgun_pickup", Dynamic_Wrap(GameMode, 'On_physgun_pickup'), self)
	ListenToGameEvent("flare_ignite_npc", Dynamic_Wrap(GameMode, 'On_flare_ignite_npc'), self)
	ListenToGameEvent("helicopter_grenade_punt_miss", Dynamic_Wrap(GameMode, 'On_helicopter_grenade_punt_miss'), self)
	ListenToGameEvent("user_data_downloaded", Dynamic_Wrap(GameMode, 'On_user_data_downloaded'), self)
	ListenToGameEvent("ragdoll_dissolved", Dynamic_Wrap(GameMode, 'On_ragdoll_dissolved'), self)
	ListenToGameEvent("gameinstructor_draw", Dynamic_Wrap(GameMode, 'On_gameinstructor_draw'), self)
	ListenToGameEvent("gameinstructor_nodraw", Dynamic_Wrap(GameMode, 'On_gameinstructor_nodraw'), self)
	ListenToGameEvent("map_transition", Dynamic_Wrap(GameMode, 'On_map_transition'), self)
	ListenToGameEvent("instructor_server_hint_create", Dynamic_Wrap(GameMode, 'On_instructor_server_hint_create'), self)
	ListenToGameEvent("instructor_server_hint_stop", Dynamic_Wrap(GameMode, 'On_instructor_server_hint_stop'), self)
	ListenToGameEvent("chat_new_message", Dynamic_Wrap(GameMode, 'On_chat_new_message'), self)
	ListenToGameEvent("chat_members_changed", Dynamic_Wrap(GameMode, 'On_chat_members_changed'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GameMode, 'On_game_rules_state_change'), self)
	ListenToGameEvent("inventory_updated", Dynamic_Wrap(GameMode, 'On_inventory_updated'), self)
	ListenToGameEvent("cart_updated", Dynamic_Wrap(GameMode, 'On_cart_updated'), self)
	ListenToGameEvent("store_pricesheet_updated", Dynamic_Wrap(GameMode, 'On_store_pricesheet_updated'), self)
	ListenToGameEvent("gc_connected", Dynamic_Wrap(GameMode, 'On_gc_connected'), self)
	ListenToGameEvent("item_schema_initialized", Dynamic_Wrap(GameMode, 'On_item_schema_initialized'), self)
	ListenToGameEvent("drop_rate_modified", Dynamic_Wrap(GameMode, 'On_drop_rate_modified'), self)
	ListenToGameEvent("event_ticket_modified", Dynamic_Wrap(GameMode, 'On_event_ticket_modified'), self)
	ListenToGameEvent("modifier_event", Dynamic_Wrap(GameMode, 'On_modifier_event'), self)
	ListenToGameEvent("dota_player_kill", Dynamic_Wrap(GameMode, 'On_dota_player_kill'), self)
	ListenToGameEvent("dota_player_deny", Dynamic_Wrap(GameMode, 'On_dota_player_deny'), self)
	ListenToGameEvent("dota_barracks_kill", Dynamic_Wrap(GameMode, 'On_dota_barracks_kill'), self)
	ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(GameMode, 'On_dota_tower_kill'), self)
	ListenToGameEvent("dota_roshan_kill", Dynamic_Wrap(GameMode, 'On_dota_roshan_kill'), self)
	ListenToGameEvent("dota_courier_lost", Dynamic_Wrap(GameMode, 'On_dota_courier_lost'), self)
	ListenToGameEvent("dota_courier_respawned", Dynamic_Wrap(GameMode, 'On_dota_courier_respawned'), self)
	ListenToGameEvent("dota_glyph_used", Dynamic_Wrap(GameMode, 'On_dota_glyph_used'), self)
	ListenToGameEvent("dota_super_creeps", Dynamic_Wrap(GameMode, 'On_dota_super_creeps'), self)
	ListenToGameEvent("dota_item_purchase", Dynamic_Wrap(GameMode, 'On_dota_item_purchase'), self)
	ListenToGameEvent("dota_item_gifted", Dynamic_Wrap(GameMode, 'On_dota_item_gifted'), self)
	ListenToGameEvent("dota_rune_pickup", Dynamic_Wrap(GameMode, 'On_dota_rune_pickup'), self)
	ListenToGameEvent("dota_rune_spotted", Dynamic_Wrap(GameMode, 'On_dota_rune_spotted'), self)
	ListenToGameEvent("dota_item_spotted", Dynamic_Wrap(GameMode, 'On_dota_item_spotted'), self)
	ListenToGameEvent("dota_no_battle_points", Dynamic_Wrap(GameMode, 'On_dota_no_battle_points'), self)
	ListenToGameEvent("dota_chat_informational", Dynamic_Wrap(GameMode, 'On_dota_chat_informational'), self)
	ListenToGameEvent("dota_action_item", Dynamic_Wrap(GameMode, 'On_dota_action_item'), self)
	ListenToGameEvent("dota_chat_ban_notification", Dynamic_Wrap(GameMode, 'On_dota_chat_ban_notification'), self)
	ListenToGameEvent("dota_chat_event", Dynamic_Wrap(GameMode, 'On_dota_chat_event'), self)
	ListenToGameEvent("dota_chat_timed_reward", Dynamic_Wrap(GameMode, 'On_dota_chat_timed_reward'), self)
	ListenToGameEvent("dota_pause_event", Dynamic_Wrap(GameMode, 'On_dota_pause_event'), self)
	ListenToGameEvent("dota_chat_kill_streak", Dynamic_Wrap(GameMode, 'On_dota_chat_kill_streak'), self)
	ListenToGameEvent("dota_chat_first_blood", Dynamic_Wrap(GameMode, 'On_dota_chat_first_blood'), self)
	ListenToGameEvent("dota_player_update_hero_selection", Dynamic_Wrap(GameMode, 'On_dota_player_update_hero_selection'), self)
	ListenToGameEvent("dota_player_update_selected_unit", Dynamic_Wrap(GameMode, 'On_dota_player_update_selected_unit'), self)
	ListenToGameEvent("dota_player_update_query_unit", Dynamic_Wrap(GameMode, 'On_dota_player_update_query_unit'), self)
	ListenToGameEvent("dota_player_update_killcam_unit", Dynamic_Wrap(GameMode, 'On_dota_player_update_killcam_unit'), self)
	ListenToGameEvent("dota_player_take_tower_damage", Dynamic_Wrap(GameMode, 'On_dota_player_take_tower_damage'), self)
	ListenToGameEvent("dota_hud_error_message", Dynamic_Wrap(GameMode, 'On_dota_hud_error_message'), self)
	ListenToGameEvent("dota_action_success", Dynamic_Wrap(GameMode, 'On_dota_action_success'), self)
	ListenToGameEvent("dota_starting_position_changed", Dynamic_Wrap(GameMode, 'On_dota_starting_position_changed'), self)
	ListenToGameEvent("dota_money_changed", Dynamic_Wrap(GameMode, 'On_dota_money_changed'), self)
	ListenToGameEvent("dota_enemy_money_changed", Dynamic_Wrap(GameMode, 'On_dota_enemy_money_changed'), self)
	ListenToGameEvent("dota_portrait_unit_stats_changed", Dynamic_Wrap(GameMode, 'On_dota_portrait_unit_stats_changed'), self)
	ListenToGameEvent("dota_portrait_unit_modifiers_changed", Dynamic_Wrap(GameMode, 'On_dota_portrait_unit_modifiers_changed'), self)
	ListenToGameEvent("dota_force_portrait_update", Dynamic_Wrap(GameMode, 'On_dota_force_portrait_update'), self)
	ListenToGameEvent("dota_inventory_changed", Dynamic_Wrap(GameMode, 'On_dota_inventory_changed'), self)
	ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(GameMode, 'On_dota_item_picked_up'), self)
	ListenToGameEvent("dota_inventory_item_changed", Dynamic_Wrap(GameMode, 'On_dota_inventory_item_changed'), self)
	ListenToGameEvent("dota_ability_changed", Dynamic_Wrap(GameMode, 'On_dota_ability_changed'), self)
	ListenToGameEvent("dota_portrait_ability_layout_changed", Dynamic_Wrap(GameMode, 'On_dota_portrait_ability_layout_changed'), self)
	ListenToGameEvent("dota_inventory_item_added", Dynamic_Wrap(GameMode, 'On_dota_inventory_item_added'), self)
	ListenToGameEvent("dota_inventory_changed_query_unit", Dynamic_Wrap(GameMode, 'On_dota_inventory_changed_query_unit'), self)
	ListenToGameEvent("dota_link_clicked", Dynamic_Wrap(GameMode, 'On_dota_link_clicked'), self)
	ListenToGameEvent("dota_set_quick_buy", Dynamic_Wrap(GameMode, 'On_dota_set_quick_buy'), self)
	ListenToGameEvent("dota_quick_buy_changed", Dynamic_Wrap(GameMode, 'On_dota_quick_buy_changed'), self)
	ListenToGameEvent("dota_player_shop_changed", Dynamic_Wrap(GameMode, 'On_dota_player_shop_changed'), self)
	ListenToGameEvent("dota_player_show_killcam", Dynamic_Wrap(GameMode, 'On_dota_player_show_killcam'), self)
	ListenToGameEvent("dota_player_show_minikillcam", Dynamic_Wrap(GameMode, 'On_dota_player_show_minikillcam'), self)
	ListenToGameEvent("gc_user_session_created", Dynamic_Wrap(GameMode, 'On_gc_user_session_created'), self)
	ListenToGameEvent("team_data_updated", Dynamic_Wrap(GameMode, 'On_team_data_updated'), self)
	ListenToGameEvent("guild_data_updated", Dynamic_Wrap(GameMode, 'On_guild_data_updated'), self)
	ListenToGameEvent("guild_open_parties_updated", Dynamic_Wrap(GameMode, 'On_guild_open_parties_updated'), self)
	ListenToGameEvent("fantasy_updated", Dynamic_Wrap(GameMode, 'On_fantasy_updated'), self)
	ListenToGameEvent("fantasy_league_changed", Dynamic_Wrap(GameMode, 'On_fantasy_league_changed'), self)
	ListenToGameEvent("fantasy_score_info_changed", Dynamic_Wrap(GameMode, 'On_fantasy_score_info_changed'), self)
	ListenToGameEvent("player_info_updated", Dynamic_Wrap(GameMode, 'On_player_info_updated'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(GameMode, 'On_game_rules_state_change'), self)
	ListenToGameEvent("match_history_updated", Dynamic_Wrap(GameMode, 'On_match_history_updated'), self)
	ListenToGameEvent("match_details_updated", Dynamic_Wrap(GameMode, 'On_match_details_updated'), self)
	ListenToGameEvent("live_games_updated", Dynamic_Wrap(GameMode, 'On_live_games_updated'), self)
	ListenToGameEvent("recent_matches_updated", Dynamic_Wrap(GameMode, 'On_recent_matches_updated'), self)
	ListenToGameEvent("news_updated", Dynamic_Wrap(GameMode, 'On_news_updated'), self)
	ListenToGameEvent("persona_updated", Dynamic_Wrap(GameMode, 'On_persona_updated'), self)
	ListenToGameEvent("tournament_state_updated", Dynamic_Wrap(GameMode, 'On_tournament_state_updated'), self)
	ListenToGameEvent("party_updated", Dynamic_Wrap(GameMode, 'On_party_updated'), self)
	ListenToGameEvent("lobby_updated", Dynamic_Wrap(GameMode, 'On_lobby_updated'), self)
	ListenToGameEvent("dashboard_caches_cleared", Dynamic_Wrap(GameMode, 'On_dashboard_caches_cleared'), self)
	ListenToGameEvent("last_hit", Dynamic_Wrap(GameMode, 'On_last_hit'), self)
	ListenToGameEvent("player_completed_game", Dynamic_Wrap(GameMode, 'On_player_completed_game'), self)
	ListenToGameEvent("dota_combatlog", Dynamic_Wrap(GameMode, 'On_dota_combatlog'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'On_player_reconnected'), self)
	ListenToGameEvent("nommed_tree", Dynamic_Wrap(GameMode, 'On_nommed_tree'), self)
	ListenToGameEvent("dota_rune_activated_server", Dynamic_Wrap(GameMode, 'On_dota_rune_activated_server'), self)
	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(GameMode, 'On_dota_player_gained_level'), self)
	ListenToGameEvent("dota_player_pick_hero", Dynamic_Wrap(GameMode, 'On_dota_player_pick_hero'), self)
	ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(GameMode, 'On_dota_player_learned_ability'), self)
	ListenToGameEvent("dota_player_used_ability", Dynamic_Wrap(GameMode, 'On_dota_player_used_ability'), self)
	ListenToGameEvent("dota_non_player_used_ability", Dynamic_Wrap(GameMode, 'On_dota_non_player_used_ability'), self)
	ListenToGameEvent("dota_ability_channel_finished", Dynamic_Wrap(GameMode, 'On_dota_ability_channel_finished'), self)
	ListenToGameEvent("dota_holdout_revive_complete", Dynamic_Wrap(GameMode, 'On_dota_holdout_revive_complete'), self)
	ListenToGameEvent("dota_player_killed", Dynamic_Wrap(GameMode, 'On_dota_player_killed'), self)
	ListenToGameEvent("bindpanel_open", Dynamic_Wrap(GameMode, 'On_bindpanel_open'), self)
	ListenToGameEvent("bindpanel_close", Dynamic_Wrap(GameMode, 'On_bindpanel_close'), self)
	ListenToGameEvent("keybind_changed", Dynamic_Wrap(GameMode, 'On_keybind_changed'), self)
	ListenToGameEvent("dota_item_drag_begin", Dynamic_Wrap(GameMode, 'On_dota_item_drag_begin'), self)
	ListenToGameEvent("dota_item_drag_end", Dynamic_Wrap(GameMode, 'On_dota_item_drag_end'), self)
	ListenToGameEvent("dota_shop_item_drag_begin", Dynamic_Wrap(GameMode, 'On_dota_shop_item_drag_begin'), self)
	ListenToGameEvent("dota_shop_item_drag_end", Dynamic_Wrap(GameMode, 'On_dota_shop_item_drag_end'), self)
	ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(GameMode, 'On_dota_item_purchased'), self)
	ListenToGameEvent("dota_item_used", Dynamic_Wrap(GameMode, 'On_dota_item_used'), self)
	ListenToGameEvent("dota_item_auto_purchase", Dynamic_Wrap(GameMode, 'On_dota_item_auto_purchase'), self)
	ListenToGameEvent("dota_unit_event", Dynamic_Wrap(GameMode, 'On_dota_unit_event'), self)
	ListenToGameEvent("dota_quest_started", Dynamic_Wrap(GameMode, 'On_dota_quest_started'), self)
	ListenToGameEvent("dota_quest_completed", Dynamic_Wrap(GameMode, 'On_dota_quest_completed'), self)
	ListenToGameEvent("gameui_activated", Dynamic_Wrap(GameMode, 'On_gameui_activated'), self)
	ListenToGameEvent("gameui_hidden", Dynamic_Wrap(GameMode, 'On_gameui_hidden'), self)
	ListenToGameEvent("player_fullyjoined", Dynamic_Wrap(GameMode, 'On_player_fullyjoined'), self)
	ListenToGameEvent("dota_spectate_hero", Dynamic_Wrap(GameMode, 'On_dota_spectate_hero'), self)
	ListenToGameEvent("dota_match_done", Dynamic_Wrap(GameMode, 'On_dota_match_done'), self)
	ListenToGameEvent("dota_match_done_client", Dynamic_Wrap(GameMode, 'On_dota_match_done_client'), self)
	ListenToGameEvent("set_instructor_group_enabled", Dynamic_Wrap(GameMode, 'On_set_instructor_group_enabled'), self)
	ListenToGameEvent("joined_chat_channel", Dynamic_Wrap(GameMode, 'On_joined_chat_channel'), self)
	ListenToGameEvent("left_chat_channel", Dynamic_Wrap(GameMode, 'On_left_chat_channel'), self)
	ListenToGameEvent("gc_chat_channel_list_updated", Dynamic_Wrap(GameMode, 'On_gc_chat_channel_list_updated'), self)
	ListenToGameEvent("today_messages_updated", Dynamic_Wrap(GameMode, 'On_today_messages_updated'), self)
	ListenToGameEvent("file_downloaded", Dynamic_Wrap(GameMode, 'On_file_downloaded'), self)
	ListenToGameEvent("player_report_counts_updated", Dynamic_Wrap(GameMode, 'On_player_report_counts_updated'), self)
	ListenToGameEvent("scaleform_file_download_complete", Dynamic_Wrap(GameMode, 'On_scaleform_file_download_complete'), self)
	ListenToGameEvent("item_purchased", Dynamic_Wrap(GameMode, 'On_item_purchased'), self)
	ListenToGameEvent("gc_mismatched_version", Dynamic_Wrap(GameMode, 'On_gc_mismatched_version'), self)
	ListenToGameEvent("demo_skip", Dynamic_Wrap(GameMode, 'On_demo_skip'), self)
	ListenToGameEvent("demo_start", Dynamic_Wrap(GameMode, 'On_demo_start'), self)
	ListenToGameEvent("demo_stop", Dynamic_Wrap(GameMode, 'On_demo_stop'), self)
	ListenToGameEvent("map_shutdown", Dynamic_Wrap(GameMode, 'On_map_shutdown'), self)
	ListenToGameEvent("dota_workshop_fileselected", Dynamic_Wrap(GameMode, 'On_dota_workshop_fileselected'), self)
	ListenToGameEvent("dota_workshop_filecanceled", Dynamic_Wrap(GameMode, 'On_dota_workshop_filecanceled'), self)
	ListenToGameEvent("rich_presence_updated", Dynamic_Wrap(GameMode, 'On_rich_presence_updated'), self)
	ListenToGameEvent("dota_hero_random", Dynamic_Wrap(GameMode, 'On_dota_hero_random'), self)
	ListenToGameEvent("dota_rd_chat_turn", Dynamic_Wrap(GameMode, 'On_dota_rd_chat_turn'), self)
	ListenToGameEvent("dota_favorite_heroes_updated", Dynamic_Wrap(GameMode, 'On_dota_favorite_heroes_updated'), self)
	ListenToGameEvent("profile_closed", Dynamic_Wrap(GameMode, 'On_profile_closed'), self)
	ListenToGameEvent("item_preview_closed", Dynamic_Wrap(GameMode, 'On_item_preview_closed'), self)
	ListenToGameEvent("dashboard_switched_section", Dynamic_Wrap(GameMode, 'On_dashboard_switched_section'), self)
	ListenToGameEvent("dota_tournament_item_event", Dynamic_Wrap(GameMode, 'On_dota_tournament_item_event'), self)
	ListenToGameEvent("dota_hero_swap", Dynamic_Wrap(GameMode, 'On_dota_hero_swap'), self)
	ListenToGameEvent("dota_reset_suggested_items", Dynamic_Wrap(GameMode, 'On_dota_reset_suggested_items'), self)
	ListenToGameEvent("halloween_high_score_received", Dynamic_Wrap(GameMode, 'On_halloween_high_score_received'), self)
	ListenToGameEvent("halloween_phase_end", Dynamic_Wrap(GameMode, 'On_halloween_phase_end'), self)
	ListenToGameEvent("halloween_high_score_request_failed", Dynamic_Wrap(GameMode, 'On_halloween_high_score_request_failed'), self)
	ListenToGameEvent("dota_hud_skin_changed", Dynamic_Wrap(GameMode, 'On_dota_hud_skin_changed'), self)
	ListenToGameEvent("dota_inventory_player_got_item", Dynamic_Wrap(GameMode, 'On_dota_inventory_player_got_item'), self)
	ListenToGameEvent("player_is_experienced", Dynamic_Wrap(GameMode, 'On_player_is_experienced'), self)
	ListenToGameEvent("player_is_notexperienced", Dynamic_Wrap(GameMode, 'On_player_is_notexperienced'), self)
	ListenToGameEvent("dota_tutorial_lesson_start", Dynamic_Wrap(GameMode, 'On_dota_tutorial_lesson_start'), self)
	ListenToGameEvent("map_location_updated", Dynamic_Wrap(GameMode, 'On_map_location_updated'), self)
	ListenToGameEvent("richpresence_custom_updated", Dynamic_Wrap(GameMode, 'On_richpresence_custom_updated'), self)
	ListenToGameEvent("game_end_visible", Dynamic_Wrap(GameMode, 'On_game_end_visible'), self)
	ListenToGameEvent("antiaddiction_update", Dynamic_Wrap(GameMode, 'On_antiaddiction_update'), self)
	ListenToGameEvent("highlight_hud_element", Dynamic_Wrap(GameMode, 'On_highlight_hud_element'), self)
	ListenToGameEvent("hide_highlight_hud_element", Dynamic_Wrap(GameMode, 'On_hide_highlight_hud_element'), self)
	ListenToGameEvent("intro_video_finished", Dynamic_Wrap(GameMode, 'On_intro_video_finished'), self)
	ListenToGameEvent("matchmaking_status_visibility_changed", Dynamic_Wrap(GameMode, 'On_matchmaking_status_visibility_changed'), self)
	ListenToGameEvent("practice_lobby_visibility_changed", Dynamic_Wrap(GameMode, 'On_practice_lobby_visibility_changed'), self)
	ListenToGameEvent("dota_courier_transfer_item", Dynamic_Wrap(GameMode, 'On_dota_courier_transfer_item'), self)
	ListenToGameEvent("full_ui_unlocked", Dynamic_Wrap(GameMode, 'On_full_ui_unlocked'), self)
	ListenToGameEvent("client_connectionless_packet", Dynamic_Wrap(GameMode, 'On_client_connectionless_packet'), self)
	ListenToGameEvent("hero_selector_preview_set", Dynamic_Wrap(GameMode, 'On_hero_selector_preview_set'), self)
	ListenToGameEvent("antiaddiction_toast", Dynamic_Wrap(GameMode, 'On_antiaddiction_toast'), self)
	ListenToGameEvent("hero_picker_shown", Dynamic_Wrap(GameMode, 'On_hero_picker_shown'), self)
	ListenToGameEvent("hero_picker_hidden", Dynamic_Wrap(GameMode, 'On_hero_picker_hidden'), self)
	ListenToGameEvent("dota_local_quickbuy_changed", Dynamic_Wrap(GameMode, 'On_dota_local_quickbuy_changed'), self)
	ListenToGameEvent("show_center_message", Dynamic_Wrap(GameMode, 'On_show_center_message'), self)
	ListenToGameEvent("hud_flip_changed", Dynamic_Wrap(GameMode, 'On_hud_flip_changed'), self)
	ListenToGameEvent("frosty_points_updated", Dynamic_Wrap(GameMode, 'On_frosty_points_updated'), self)
	ListenToGameEvent("defeated", Dynamic_Wrap(GameMode, 'On_defeated'), self)
	ListenToGameEvent("reset_defeated", Dynamic_Wrap(GameMode, 'On_reset_defeated'), self)
	ListenToGameEvent("booster_state_updated", Dynamic_Wrap(GameMode, 'On_booster_state_updated'), self)
	ListenToGameEvent("event_points_updated", Dynamic_Wrap(GameMode, 'On_event_points_updated'), self)
	ListenToGameEvent("local_player_event_points", Dynamic_Wrap(GameMode, 'On_local_player_event_points'), self)
	ListenToGameEvent("custom_game_difficulty", Dynamic_Wrap(GameMode, 'On_custom_game_difficulty'), self)
	ListenToGameEvent("tree_cut", Dynamic_Wrap(GameMode, 'On_tree_cut'), self)
	ListenToGameEvent("ugc_details_arrived", Dynamic_Wrap(GameMode, 'On_ugc_details_arrived'), self)
	ListenToGameEvent("ugc_subscribed", Dynamic_Wrap(GameMode, 'On_ugc_subscribed'), self)
	ListenToGameEvent("ugc_unsubscribed", Dynamic_Wrap(GameMode, 'On_ugc_unsubscribed'), self)
	ListenToGameEvent("prizepool_received", Dynamic_Wrap(GameMode, 'On_prizepool_received'), self)
	ListenToGameEvent("microtransaction_success", Dynamic_Wrap(GameMode, 'On_microtransaction_success'), self)
	ListenToGameEvent("dota_rubick_ability_steal", Dynamic_Wrap(GameMode, 'On_dota_rubick_ability_steal'), self)
	ListenToGameEvent("compendium_event_actions_loaded", Dynamic_Wrap(GameMode, 'On_compendium_event_actions_loaded'), self)
	ListenToGameEvent("compendium_selections_loaded", Dynamic_Wrap(GameMode, 'On_compendium_selections_loaded'), self)
	ListenToGameEvent("compendium_set_selection_failed", Dynamic_Wrap(GameMode, 'On_compendium_set_selection_failed'), self)
	ListenToGameEvent("community_cached_names_updated", Dynamic_Wrap(GameMode, 'On_community_cached_names_updated'), self)
	ListenToGameEvent("dota_team_kill_credit", Dynamic_Wrap(GameMode, 'On_dota_team_kill_credit'), self)
end

function GameMode:On_team_info(data)
  DebugPrint("[BAREBONES] team_info")
  DebugPrintTable(data)
end


function GameMode:On_team_score(data)
  DebugPrint("[BAREBONES] team_score")
  DebugPrintTable(data)
end


function GameMode:On_teamplay_broadcast_audio(data)
  DebugPrint("[BAREBONES] teamplay_broadcast_audio")
  DebugPrintTable(data)
end


function GameMode:On_player_team(data)
  DebugPrint("[BAREBONES] player_team")
  DebugPrintTable(data)
end


function GameMode:On_player_class(data)
  DebugPrint("[BAREBONES] player_class")
  DebugPrintTable(data)
end


function GameMode:On_player_death (data)
  DebugPrint("[BAREBONES] player_death")
  DebugPrintTable(data)
end


function GameMode:On_player_hurt (data)
  DebugPrint("[BAREBONES] player_hurt")
  DebugPrintTable(data)
end


function GameMode:On_player_chat (data)
  DebugPrint("[BAREBONES] player_chat")
  DebugPrintTable(data)
end


function GameMode:On_player_score(data)
  DebugPrint("[BAREBONES] player_score")
  DebugPrintTable(data)
end


function GameMode:On_player_spawn(data)
  DebugPrint("[BAREBONES] player_spawn")
  DebugPrintTable(data)
end


function GameMode:On_player_shoot(data)
  DebugPrint("[BAREBONES] player_shoot")
  DebugPrintTable(data)
end


function GameMode:On_player_use(data)
  DebugPrint("[BAREBONES] player_use")
  DebugPrintTable(data)
end


function GameMode:On_player_changename(data)
  DebugPrint("[BAREBONES] player_changename")
  DebugPrintTable(data)
end


function GameMode:On_player_hintmessage(data)
  DebugPrint("[BAREBONES] player_hintmessage")
  DebugPrintTable(data)
end


function GameMode:On_player_reconnected (data)
  DebugPrint("[BAREBONES] player_reconnected")
  DebugPrintTable(data)
end


function GameMode:On_game_init(data)
  DebugPrint("[BAREBONES] game_init")
  DebugPrintTable(data)
end


function GameMode:On_game_newmap(data)
  DebugPrint("[BAREBONES] game_newmap")
  DebugPrintTable(data)
end


function GameMode:On_game_start(data)
  DebugPrint("[BAREBONES] game_start")
  DebugPrintTable(data)
end


function GameMode:On_game_end(data)
  DebugPrint("[BAREBONES] game_end")
  DebugPrintTable(data)
end


function GameMode:On_round_start(data)
  DebugPrint("[BAREBONES] round_start")
  DebugPrintTable(data)
end


function GameMode:On_round_end(data)
  DebugPrint("[BAREBONES] round_end")
  DebugPrintTable(data)
end


function GameMode:On_round_start_pre_entity(data)
  DebugPrint("[BAREBONES] round_start_pre_entity")
  DebugPrintTable(data)
end


function GameMode:On_teamplay_round_start(data)
  DebugPrint("[BAREBONES] teamplay_round_start")
  DebugPrintTable(data)
end


function GameMode:On_hostname_changed(data)
  DebugPrint("[BAREBONES] hostname_changed")
  DebugPrintTable(data)
end


function GameMode:On_difficulty_changed(data)
  DebugPrint("[BAREBONES] difficulty_changed")
  DebugPrintTable(data)
end


function GameMode:On_finale_start(data)
  DebugPrint("[BAREBONES] finale_start")
  DebugPrintTable(data)
end


function GameMode:On_game_message(data)
  DebugPrint("[BAREBONES] game_message")
  DebugPrintTable(data)
end


function GameMode:On_break_breakable(data)
  DebugPrint("[BAREBONES] break_breakable")
  DebugPrintTable(data)
end


function GameMode:On_break_prop(data)
  DebugPrint("[BAREBONES] break_prop")
  DebugPrintTable(data)
end


function GameMode:On_npc_spawned(data)
  DebugPrint("[BAREBONES] npc_spawned")
  DebugPrintTable(data)
end


function GameMode:On_npc_replaced(data)
  DebugPrint("[BAREBONES] npc_replaced")
  DebugPrintTable(data)
end


function GameMode:On_entity_killed(data)
  DebugPrint("[BAREBONES] entity_killed")
  DebugPrintTable(data)
end


function GameMode:On_entity_hurt(data)
  DebugPrint("[BAREBONES] entity_hurt")
  DebugPrintTable(data)
end


function GameMode:On_bonus_updated(data)
  DebugPrint("[BAREBONES] bonus_updated")
  DebugPrintTable(data)
end


function GameMode:On_player_stats_updated(data)
  DebugPrint("[BAREBONES] player_stats_updated")
  DebugPrintTable(data)
end


function GameMode:On_achievement_event(data)
  DebugPrint("[BAREBONES] achievement_event")
  DebugPrintTable(data)
end


function GameMode:On_achievement_earned(data)
  DebugPrint("[BAREBONES] achievement_earned")
  DebugPrintTable(data)
end


function GameMode:On_achievement_write_failed(data)
  DebugPrint("[BAREBONES] achievement_write_failed")
  DebugPrintTable(data)
end


function GameMode:On_physgun_pickup(data)
  DebugPrint("[BAREBONES] physgun_pickup")
  DebugPrintTable(data)
end


function GameMode:On_flare_ignite_npc(data)
  DebugPrint("[BAREBONES] flare_ignite_npc")
  DebugPrintTable(data)
end


function GameMode:On_helicopter_grenade_punt_miss(data)
  DebugPrint("[BAREBONES] helicopter_grenade_punt_miss")
  DebugPrintTable(data)
end


function GameMode:On_user_data_downloaded(data)
  DebugPrint("[BAREBONES] user_data_downloaded")
  DebugPrintTable(data)
end


function GameMode:On_ragdoll_dissolved(data)
  DebugPrint("[BAREBONES] ragdoll_dissolved")
  DebugPrintTable(data)
end


function GameMode:On_gameinstructor_draw(data)
  DebugPrint("[BAREBONES] gameinstructor_draw")
  DebugPrintTable(data)
end


function GameMode:On_gameinstructor_nodraw(data)
  DebugPrint("[BAREBONES] gameinstructor_nodraw")
  DebugPrintTable(data)
end


function GameMode:On_map_transition(data)
  DebugPrint("[BAREBONES] map_transition")
  DebugPrintTable(data)
end


function GameMode:On_instructor_server_hint_create(data)
  DebugPrint("[BAREBONES] instructor_server_hint_create")
  DebugPrintTable(data)
end


function GameMode:On_instructor_server_hint_stop(data)
  DebugPrint("[BAREBONES] instructor_server_hint_stop")
  DebugPrintTable(data)
end


function GameMode:On_chat_new_message(data)
  DebugPrint("[BAREBONES] chat_new_message")
  DebugPrintTable(data)
end


function GameMode:On_chat_members_changed(data)
  DebugPrint("[BAREBONES] chat_members_changed")
  DebugPrintTable(data)
end


function GameMode:On_game_rules_state_change(data)
  DebugPrint("[BAREBONES] game_rules_state_change")
  DebugPrintTable(data)
end


function GameMode:On_inventory_updated(data)
  DebugPrint("[BAREBONES] inventory_updated")
  DebugPrintTable(data)
end


function GameMode:On_cart_updated(data)
  DebugPrint("[BAREBONES] cart_updated")
  DebugPrintTable(data)
end


function GameMode:On_store_pricesheet_updated(data)
  DebugPrint("[BAREBONES] store_pricesheet_updated")
  DebugPrintTable(data)
end


function GameMode:On_gc_connected(data)
  DebugPrint("[BAREBONES] gc_connected")
  DebugPrintTable(data)
end


function GameMode:On_item_schema_initialized(data)
  DebugPrint("[BAREBONES] item_schema_initialized")
  DebugPrintTable(data)
end


function GameMode:On_drop_rate_modified(data)
  DebugPrint("[BAREBONES] drop_rate_modified")
  DebugPrintTable(data)
end


function GameMode:On_event_ticket_modified(data)
  DebugPrint("[BAREBONES] event_ticket_modified")
  DebugPrintTable(data)
end


function GameMode:On_modifier_event(data)
  DebugPrint("[BAREBONES] modifier_event")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_kill(data)
  DebugPrint("[BAREBONES] dota_player_kill")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_deny(data)
  DebugPrint("[BAREBONES] dota_player_deny")
  DebugPrintTable(data)
end


function GameMode:On_dota_barracks_kill(data)
  DebugPrint("[BAREBONES] dota_barracks_kill")
  DebugPrintTable(data)
end


function GameMode:On_dota_tower_kill(data)
  DebugPrint("[BAREBONES] dota_tower_kill")
  DebugPrintTable(data)
end


function GameMode:On_dota_roshan_kill(data)
  DebugPrint("[BAREBONES] dota_roshan_kill")
  DebugPrintTable(data)
end


function GameMode:On_dota_courier_lost(data)
  DebugPrint("[BAREBONES] dota_courier_lost")
  DebugPrintTable(data)
end


function GameMode:On_dota_courier_respawned(data)
  DebugPrint("[BAREBONES] dota_courier_respawned")
  DebugPrintTable(data)
end


function GameMode:On_dota_glyph_used(data)
  DebugPrint("[BAREBONES] dota_glyph_used")
  DebugPrintTable(data)
end


function GameMode:On_dota_super_creeps(data)
  DebugPrint("[BAREBONES] dota_super_creeps")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_purchase(data)
  DebugPrint("[BAREBONES] dota_item_purchase")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_gifted(data)
  DebugPrint("[BAREBONES] dota_item_gifted")
  DebugPrintTable(data)
end


function GameMode:On_dota_rune_pickup(data)
  DebugPrint("[BAREBONES] dota_rune_pickup")
  DebugPrintTable(data)
end


function GameMode:On_dota_rune_spotted(data)
  DebugPrint("[BAREBONES] dota_rune_spotted")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_spotted(data)
  DebugPrint("[BAREBONES] dota_item_spotted")
  DebugPrintTable(data)
end


function GameMode:On_dota_no_battle_points(data)
  DebugPrint("[BAREBONES] dota_no_battle_points")
  DebugPrintTable(data)
end


function GameMode:On_dota_chat_informational(data)
  DebugPrint("[BAREBONES] dota_chat_informational")
  DebugPrintTable(data)
end


function GameMode:On_dota_action_item(data)
  DebugPrint("[BAREBONES] dota_action_item")
  DebugPrintTable(data)
end


function GameMode:On_dota_chat_ban_notification(data)
  DebugPrint("[BAREBONES] dota_chat_ban_notification")
  DebugPrintTable(data)
end


function GameMode:On_dota_chat_event(data)
  DebugPrint("[BAREBONES] dota_chat_event")
  DebugPrintTable(data)
end


function GameMode:On_dota_chat_timed_reward(data)
  DebugPrint("[BAREBONES] dota_chat_timed_reward")
  DebugPrintTable(data)
end


function GameMode:On_dota_pause_event(data)
  DebugPrint("[BAREBONES] dota_pause_event")
  DebugPrintTable(data)
end


function GameMode:On_dota_chat_kill_streak(data)
  DebugPrint("[BAREBONES] dota_chat_kill_streak")
  DebugPrintTable(data)
end


function GameMode:On_dota_chat_first_blood(data)
  DebugPrint("[BAREBONES] dota_chat_first_blood")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_update_hero_selection(data)
  DebugPrint("[BAREBONES] dota_player_update_hero_selection")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_update_selected_unit(data)
  DebugPrint("[BAREBONES] dota_player_update_selected_unit")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_update_query_unit(data)
  DebugPrint("[BAREBONES] dota_player_update_query_unit")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_update_killcam_unit(data)
  DebugPrint("[BAREBONES] dota_player_update_killcam_unit")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_take_tower_damage(data)
  DebugPrint("[BAREBONES] dota_player_take_tower_damage")
  DebugPrintTable(data)
end


function GameMode:On_dota_hud_error_message(data)
  DebugPrint("[BAREBONES] dota_hud_error_message")
  DebugPrintTable(data)
end


function GameMode:On_dota_action_success(data)
  DebugPrint("[BAREBONES] dota_action_success")
  DebugPrintTable(data)
end


function GameMode:On_dota_starting_position_changed(data)
  DebugPrint("[BAREBONES] dota_starting_position_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_money_changed(data)
  DebugPrint("[BAREBONES] dota_money_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_enemy_money_changed(data)
  DebugPrint("[BAREBONES] dota_enemy_money_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_portrait_unit_stats_changed(data)
  DebugPrint("[BAREBONES] dota_portrait_unit_stats_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_portrait_unit_modifiers_changed(data)
  DebugPrint("[BAREBONES] dota_portrait_unit_modifiers_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_force_portrait_update(data)
  DebugPrint("[BAREBONES] dota_force_portrait_update")
  DebugPrintTable(data)
end


function GameMode:On_dota_inventory_changed(data)
  DebugPrint("[BAREBONES] dota_inventory_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_picked_up(data)
  DebugPrint("[BAREBONES] dota_item_picked_up")
  DebugPrintTable(data)
end


function GameMode:On_dota_inventory_item_changed(data)
  DebugPrint("[BAREBONES] dota_inventory_item_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_ability_changed(data)
  DebugPrint("[BAREBONES] dota_ability_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_portrait_ability_layout_changed(data)
  DebugPrint("[BAREBONES] dota_portrait_ability_layout_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_inventory_item_added(data)
  DebugPrint("[BAREBONES] dota_inventory_item_added")
  DebugPrintTable(data)
end


function GameMode:On_dota_inventory_changed_query_unit(data)
  DebugPrint("[BAREBONES] dota_inventory_changed_query_unit")
  DebugPrintTable(data)
end


function GameMode:On_dota_link_clicked(data)
  DebugPrint("[BAREBONES] dota_link_clicked")
  DebugPrintTable(data)
end


function GameMode:On_dota_set_quick_buy(data)
  DebugPrint("[BAREBONES] dota_set_quick_buy")
  DebugPrintTable(data)
end


function GameMode:On_dota_quick_buy_changed(data)
  DebugPrint("[BAREBONES] dota_quick_buy_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_shop_changed(data)
  DebugPrint("[BAREBONES] dota_player_shop_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_show_killcam(data)
  DebugPrint("[BAREBONES] dota_player_show_killcam")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_show_minikillcam(data)
  DebugPrint("[BAREBONES] dota_player_show_minikillcam")
  DebugPrintTable(data)
end


function GameMode:On_gc_user_session_created(data)
  DebugPrint("[BAREBONES] gc_user_session_created")
  DebugPrintTable(data)
end


function GameMode:On_team_data_updated(data)
  DebugPrint("[BAREBONES] team_data_updated")
  DebugPrintTable(data)
end


function GameMode:On_guild_data_updated(data)
  DebugPrint("[BAREBONES] guild_data_updated")
  DebugPrintTable(data)
end


function GameMode:On_guild_open_parties_updated(data)
  DebugPrint("[BAREBONES] guild_open_parties_updated")
  DebugPrintTable(data)
end


function GameMode:On_fantasy_updated(data)
  DebugPrint("[BAREBONES] fantasy_updated")
  DebugPrintTable(data)
end


function GameMode:On_fantasy_league_changed(data)
  DebugPrint("[BAREBONES] fantasy_league_changed")
  DebugPrintTable(data)
end


function GameMode:On_fantasy_score_info_changed(data)
  DebugPrint("[BAREBONES] fantasy_score_info_changed")
  DebugPrintTable(data)
end


function GameMode:On_player_info_updated(data)
  DebugPrint("[BAREBONES] player_info_updated")
  DebugPrintTable(data)
end


function GameMode:On_game_rules_state_change(data)
  DebugPrint("[BAREBONES] game_rules_state_change")
  DebugPrintTable(data)
end


function GameMode:On_match_history_updated(data)
  DebugPrint("[BAREBONES] match_history_updated")
  DebugPrintTable(data)
end


function GameMode:On_match_details_updated(data)
  DebugPrint("[BAREBONES] match_details_updated")
  DebugPrintTable(data)
end


function GameMode:On_live_games_updated(data)
  DebugPrint("[BAREBONES] live_games_updated")
  DebugPrintTable(data)
end


function GameMode:On_recent_matches_updated(data)
  DebugPrint("[BAREBONES] recent_matches_updated")
  DebugPrintTable(data)
end


function GameMode:On_news_updated(data)
  DebugPrint("[BAREBONES] news_updated")
  DebugPrintTable(data)
end


function GameMode:On_persona_updated(data)
  DebugPrint("[BAREBONES] persona_updated")
  DebugPrintTable(data)
end


function GameMode:On_tournament_state_updated(data)
  DebugPrint("[BAREBONES] tournament_state_updated")
  DebugPrintTable(data)
end


function GameMode:On_party_updated(data)
  DebugPrint("[BAREBONES] party_updated")
  DebugPrintTable(data)
end


function GameMode:On_lobby_updated(data)
  DebugPrint("[BAREBONES] lobby_updated")
  DebugPrintTable(data)
end


function GameMode:On_dashboard_caches_cleared(data)
  DebugPrint("[BAREBONES] dashboard_caches_cleared")
  DebugPrintTable(data)
end


function GameMode:On_last_hit(data)
  DebugPrint("[BAREBONES] last_hit")
  DebugPrintTable(data)
end


function GameMode:On_player_completed_game(data)
  DebugPrint("[BAREBONES] player_completed_game")
  DebugPrintTable(data)
end

function GameMode:On_dota_combatlog(data)
  DebugPrint("[BAREBONES] dota_combatlog")
  DebugPrintTable(data)
end


function GameMode:On_player_reconnected(data)
  DebugPrint("[BAREBONES] player_reconnected")
  DebugPrintTable(data)
end


function GameMode:On_nommed_tree(data)
  DebugPrint("[BAREBONES] nommed_tree")
  DebugPrintTable(data)
end


function GameMode:On_dota_rune_activated_server(data)
  DebugPrint("[BAREBONES] dota_rune_activated_server")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_gained_level(data)
  DebugPrint("[BAREBONES] dota_player_gained_level")
  DebugPrintTable(data)
end

function GameMode:On_dota_player_pick_hero(data)
  DebugPrint("[BAREBONES] dota_player_pick_hero")
  DebugPrintTable(data)
end

function GameMode:On_dota_player_learned_ability(data)
  DebugPrint("[BAREBONES] dota_player_learned_ability")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_used_ability(data)
  DebugPrint("[BAREBONES] dota_player_used_ability")
  DebugPrintTable(data)
end


function GameMode:On_dota_non_player_used_ability(data)
  DebugPrint("[BAREBONES] dota_non_player_used_ability")
  DebugPrintTable(data)
end


function GameMode:On_dota_ability_channel_finished(data)
  DebugPrint("[BAREBONES] dota_ability_channel_finished")
  DebugPrintTable(data)
end


function GameMode:On_dota_holdout_revive_complete(data)
  DebugPrint("[BAREBONES] dota_holdout_revive_complete")
  DebugPrintTable(data)
end


function GameMode:On_dota_player_killed(data)
  DebugPrint("[BAREBONES] dota_player_killed")
  DebugPrintTable(data)
end


function GameMode:On_bindpanel_open(data)
  DebugPrint("[BAREBONES] bindpanel_open")
  DebugPrintTable(data)
end


function GameMode:On_bindpanel_close(data)
  DebugPrint("[BAREBONES] bindpanel_close")
  DebugPrintTable(data)
end


function GameMode:On_keybind_changed(data)
  DebugPrint("[BAREBONES] keybind_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_drag_begin(data)
  DebugPrint("[BAREBONES] dota_item_drag_begin")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_drag_end(data)
  DebugPrint("[BAREBONES] dota_item_drag_end")
  DebugPrintTable(data)
end


function GameMode:On_dota_shop_item_drag_begin(data)
  DebugPrint("[BAREBONES] dota_shop_item_drag_begin")
  DebugPrintTable(data)
end


function GameMode:On_dota_shop_item_drag_end(data)
  DebugPrint("[BAREBONES] dota_shop_item_drag_end")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_purchased(data)
  DebugPrint("[BAREBONES] dota_item_purchased")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_used(data)
  DebugPrint("[BAREBONES] dota_item_used")
  DebugPrintTable(data)
end


function GameMode:On_dota_item_auto_purchase(data)
  DebugPrint("[BAREBONES] dota_item_auto_purchase")
  DebugPrintTable(data)
end


function GameMode:On_dota_unit_event(data)
  DebugPrint("[BAREBONES] dota_unit_event")
  DebugPrintTable(data)
end


function GameMode:On_dota_quest_started(data)
  DebugPrint("[BAREBONES] dota_quest_started")
  DebugPrintTable(data)
end


function GameMode:On_dota_quest_completed(data)
  DebugPrint("[BAREBONES] dota_quest_completed")
  DebugPrintTable(data)
end


function GameMode:On_gameui_activated(data)
  DebugPrint("[BAREBONES] gameui_activated")
  DebugPrintTable(data)
end


function GameMode:On_gameui_hidden(data)
  DebugPrint("[BAREBONES] gameui_hidden")
  DebugPrintTable(data)
end


function GameMode:On_player_fullyjoined(data)
  DebugPrint("[BAREBONES] player_fullyjoined")
  DebugPrintTable(data)
end


function GameMode:On_dota_spectate_hero(data)
  DebugPrint("[BAREBONES] dota_spectate_hero")
  DebugPrintTable(data)
end


function GameMode:On_dota_match_done(data)
  DebugPrint("[BAREBONES] dota_match_done")
  DebugPrintTable(data)
end


function GameMode:On_dota_match_done_client(data)
  DebugPrint("[BAREBONES] dota_match_done_client")
  DebugPrintTable(data)
end


function GameMode:On_set_instructor_group_enabled(data)
  DebugPrint("[BAREBONES] set_instructor_group_enabled")
  DebugPrintTable(data)
end


function GameMode:On_joined_chat_channel(data)
  DebugPrint("[BAREBONES] joined_chat_channel")
  DebugPrintTable(data)
end


function GameMode:On_left_chat_channel(data)
  DebugPrint("[BAREBONES] left_chat_channel")
  DebugPrintTable(data)
end


function GameMode:On_gc_chat_channel_list_updated(data)
  DebugPrint("[BAREBONES] gc_chat_channel_list_updated")
  DebugPrintTable(data)
end


function GameMode:On_today_messages_updated(data)
  DebugPrint("[BAREBONES] today_messages_updated")
  DebugPrintTable(data)
end


function GameMode:On_file_downloaded(data)
  DebugPrint("[BAREBONES] file_downloaded")
  DebugPrintTable(data)
end


function GameMode:On_player_report_counts_updated(data)
  DebugPrint("[BAREBONES] player_report_counts_updated")
  DebugPrintTable(data)
end


function GameMode:On_scaleform_file_download_complete(data)
  DebugPrint("[BAREBONES] scaleform_file_download_complete")
  DebugPrintTable(data)
end


function GameMode:On_item_purchased(data)
  DebugPrint("[BAREBONES] item_purchased")
  DebugPrintTable(data)
end


function GameMode:On_gc_mismatched_version(data)
  DebugPrint("[BAREBONES] gc_mismatched_version")
  DebugPrintTable(data)
end


function GameMode:On_demo_skip(data)
  DebugPrint("[BAREBONES] demo_skip")
  DebugPrintTable(data)
end


function GameMode:On_demo_start(data)
  DebugPrint("[BAREBONES] demo_start")
  DebugPrintTable(data)
end


function GameMode:On_demo_stop(data)
  DebugPrint("[BAREBONES] demo_stop")
  DebugPrintTable(data)
end


function GameMode:On_map_shutdown(data)
  DebugPrint("[BAREBONES] map_shutdown")
  DebugPrintTable(data)
end


function GameMode:On_dota_workshop_fileselected(data)
  DebugPrint("[BAREBONES] dota_workshop_fileselected")
  DebugPrintTable(data)
end


function GameMode:On_dota_workshop_filecanceled(data)
  DebugPrint("[BAREBONES] dota_workshop_filecanceled")
  DebugPrintTable(data)
end


function GameMode:On_rich_presence_updated(data)
  DebugPrint("[BAREBONES] rich_presence_updated")
  DebugPrintTable(data)
end


function GameMode:On_dota_hero_random(data)
  DebugPrint("[BAREBONES] dota_hero_random")
  DebugPrintTable(data)
end


function GameMode:On_dota_rd_chat_turn(data)
  DebugPrint("[BAREBONES] dota_rd_chat_turn")
  DebugPrintTable(data)
end


function GameMode:On_dota_favorite_heroes_updated(data)
  DebugPrint("[BAREBONES] dota_favorite_heroes_updated")
  DebugPrintTable(data)
end


function GameMode:On_profile_closed(data)
  DebugPrint("[BAREBONES] profile_closed")
  DebugPrintTable(data)
end


function GameMode:On_item_preview_closed(data)
  DebugPrint("[BAREBONES] item_preview_closed")
  DebugPrintTable(data)
end


function GameMode:On_dashboard_switched_section(data)
  DebugPrint("[BAREBONES] dashboard_switched_section")
  DebugPrintTable(data)
end


function GameMode:On_dota_tournament_item_event(data)
  DebugPrint("[BAREBONES] dota_tournament_item_event")
  DebugPrintTable(data)
end


function GameMode:On_dota_hero_swap(data)
  DebugPrint("[BAREBONES] dota_hero_swap")
  DebugPrintTable(data)
end


function GameMode:On_dota_reset_suggested_items(data)
  DebugPrint("[BAREBONES] dota_reset_suggested_items")
  DebugPrintTable(data)
end


function GameMode:On_halloween_high_score_received(data)
  DebugPrint("[BAREBONES] halloween_high_score_received")
  DebugPrintTable(data)
end


function GameMode:On_halloween_phase_end(data)
  DebugPrint("[BAREBONES] halloween_phase_end")
  DebugPrintTable(data)
end


function GameMode:On_halloween_high_score_request_failed(data)
  DebugPrint("[BAREBONES] halloween_high_score_request_failed")
  DebugPrintTable(data)
end


function GameMode:On_dota_hud_skin_changed(data)
  DebugPrint("[BAREBONES] dota_hud_skin_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_inventory_player_got_item(data)
  DebugPrint("[BAREBONES] dota_inventory_player_got_item")
  DebugPrintTable(data)
end


function GameMode:On_player_is_experienced(data)
  DebugPrint("[BAREBONES] player_is_experienced")
  DebugPrintTable(data)
end


function GameMode:On_player_is_notexperienced(data)
  DebugPrint("[BAREBONES] player_is_notexperienced")
  DebugPrintTable(data)
end


function GameMode:On_dota_tutorial_lesson_start(data)
  DebugPrint("[BAREBONES] dota_tutorial_lesson_start")
  DebugPrintTable(data)
end


function GameMode:On_map_location_updated(data)
  DebugPrint("[BAREBONES] map_location_updated")
  DebugPrintTable(data)
end


function GameMode:On_richpresence_custom_updated(data)
  DebugPrint("[BAREBONES] richpresence_custom_updated")
  DebugPrintTable(data)
end


function GameMode:On_game_end_visible(data)
  DebugPrint("[BAREBONES] game_end_visible")
  DebugPrintTable(data)
end


function GameMode:On_antiaddiction_update(data)
  DebugPrint("[BAREBONES] antiaddiction_update")
  DebugPrintTable(data)
end


function GameMode:On_highlight_hud_element(data)
  DebugPrint("[BAREBONES] highlight_hud_element")
  DebugPrintTable(data)
end


function GameMode:On_hide_highlight_hud_element(data)
  DebugPrint("[BAREBONES] hide_highlight_hud_element")
  DebugPrintTable(data)
end


function GameMode:On_intro_video_finished(data)
  DebugPrint("[BAREBONES] intro_video_finished")
  DebugPrintTable(data)
end


function GameMode:On_matchmaking_status_visibility_changed(data)
  DebugPrint("[BAREBONES] matchmaking_status_visibility_changed")
  DebugPrintTable(data)
end


function GameMode:On_practice_lobby_visibility_changed(data)
  DebugPrint("[BAREBONES] practice_lobby_visibility_changed")
  DebugPrintTable(data)
end


function GameMode:On_dota_courier_transfer_item(data)
  DebugPrint("[BAREBONES] dota_courier_transfer_item")
  DebugPrintTable(data)
end


function GameMode:On_full_ui_unlocked(data)
  DebugPrint("[BAREBONES] full_ui_unlocked")
  DebugPrintTable(data)
end


function GameMode:On_client_connectionless_packet(data)
  DebugPrint("[BAREBONES] client_connectionless_packet")
  DebugPrintTable(data)
end


function GameMode:On_hero_selector_preview_set(data)
  DebugPrint("[BAREBONES] hero_selector_preview_set")
  DebugPrintTable(data)
end


function GameMode:On_antiaddiction_toast(data)
  DebugPrint("[BAREBONES] antiaddiction_toast")
  DebugPrintTable(data)
end


function GameMode:On_hero_picker_shown(data)
  DebugPrint("[BAREBONES] hero_picker_shown")
  DebugPrintTable(data)
end


function GameMode:On_hero_picker_hidden(data)
  DebugPrint("[BAREBONES] hero_picker_hidden")
  DebugPrintTable(data)
end


function GameMode:On_dota_local_quickbuy_changed(data)
  DebugPrint("[BAREBONES] dota_local_quickbuy_changed")
  DebugPrintTable(data)
end


function GameMode:On_show_center_message(data)
  DebugPrint("[BAREBONES] show_center_message")
  DebugPrintTable(data)
end


function GameMode:On_hud_flip_changed(data)
  DebugPrint("[BAREBONES] hud_flip_changed")
  DebugPrintTable(data)
end


function GameMode:On_frosty_points_updated(data)
  DebugPrint("[BAREBONES] frosty_points_updated")
  DebugPrintTable(data)
end


function GameMode:On_defeated(data)
  DebugPrint("[BAREBONES] defeated")
  DebugPrintTable(data)
end


function GameMode:On_reset_defeated(data)
  DebugPrint("[BAREBONES] reset_defeated")
  DebugPrintTable(data)
end


function GameMode:On_booster_state_updated(data)
  DebugPrint("[BAREBONES] booster_state_updated")
  DebugPrintTable(data)
end


function GameMode:On_event_points_updated(data)
  DebugPrint("[BAREBONES] event_points_updated")
  DebugPrintTable(data)
end


function GameMode:On_local_player_event_points(data)
  DebugPrint("[BAREBONES] local_player_event_points")
  DebugPrintTable(data)
end


function GameMode:On_custom_game_difficulty(data)
  DebugPrint("[BAREBONES] custom_game_difficulty")
  DebugPrintTable(data)
end


function GameMode:On_tree_cut(data)
  DebugPrint("[BAREBONES] tree_cut")
  DebugPrintTable(data)
end


function GameMode:On_ugc_details_arrived(data)
  DebugPrint("[BAREBONES] ugc_details_arrived")
  DebugPrintTable(data)
end


function GameMode:On_ugc_subscribed(data)
  DebugPrint("[BAREBONES] ugc_subscribed")
  DebugPrintTable(data)
end


function GameMode:On_ugc_unsubscribed(data)
  DebugPrint("[BAREBONES] ugc_unsubscribed")
  DebugPrintTable(data)
end


function GameMode:On_prizepool_received(data)
  DebugPrint("[BAREBONES] prizepool_received")
  DebugPrintTable(data)
end


function GameMode:On_microtransaction_success(data)
  DebugPrint("[BAREBONES] microtransaction_success")
  DebugPrintTable(data)
end


function GameMode:On_dota_rubick_ability_steal(data)
  DebugPrint("[BAREBONES] dota_rubick_ability_steal")
  DebugPrintTable(data)
end


function GameMode:On_compendium_event_actions_loaded(data)
  DebugPrint("[BAREBONES] compendium_event_actions_loaded")
  DebugPrintTable(data)
end


function GameMode:On_compendium_selections_loaded(data)
  DebugPrint("[BAREBONES] compendium_selections_loaded")
  DebugPrintTable(data)
end


function GameMode:On_compendium_set_selection_failed(data)
  DebugPrint("[BAREBONES] compendium_set_selection_failed")
  DebugPrintTable(data)
end

function GameMode:On_community_cached_names_updated(data)
  DebugPrint("[BAREBONES] community_cached_names_updated")
  DebugPrintTable(data)
end

function GameMode:On_dota_team_kill_credit(data)
  DebugPrint("[BAREBONES] dota_team_kill_credit")
  DebugPrintTable(data)
end