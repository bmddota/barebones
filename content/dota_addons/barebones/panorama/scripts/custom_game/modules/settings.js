'use strict';

// Apply at least some form of namespace.
// Note that this Settings module requires the modules.Utility, PopUp, and ToolTip modules.

var modules = modules || { };

(
    function()
    {
        // Class definition.

        function Settings(options)
        {
            // Internal data.

            var self = this;

            this.contentPanel = null;
            this.currentGroupID = null;
            this.currentGroupIndex = -1;
            this.groups = [ ];
            this.isHost = null;
            this.navPanel = null;
            this.radioButtons = { };
            this.textBoxes = { };
            this.settingsPanel = null;
            this.state =
                {
                    host: { },
                    local: { }
                };
            this.visible = false;
            this.wrapperPanel = null;

            // Internal methods.

            var ChangeGroup =
                function(id)
                {
                    if (id === self.currentGroupID)
                    {
                        return;
                    }

                    self.currentGroupID = id;

                    for (var i = 0, iLength = self.groups.length; i < iLength; ++i)
                    {
                        if (self.groups[i].id === id)
                        {
                            self.currentGroupIndex = i;
                            break;
                        }
                    }

                    if (self.GetVisible())
                    {
                        Show();
                    }
                };

            var CreatePanel =
                function()
                {
                    if (!self.wrapperPanel)
                    {
                        throw new Error('A wrapper panel must be set before rendering.');
                    }

                    self.settingsPanel = $.CreatePanel('Panel', self.wrapperPanel, '');
                    self.settingsPanel.BLoadLayout('file://{resources}/layout/custom_game/modules/settings.xml', false, false);
                    self.navPanel = self.settingsPanel.Children()[1].Children()[0];
                    self.contentPanel = self.settingsPanel.Children()[1].Children()[1];
                };

            var DetermineIfHost =
                function()
                {
                    var playerInfo = Game.GetLocalPlayerInfo();

                    if (playerInfo)
                    {
                        self.isHost = playerInfo.player_has_host_privileges;
                        return;
                    }

                    $.Schedule(0.1, DetermineIfHost);
                };

            var SetWrapper =
                function()
                {
                    self.settingsPanel.SetParent(self.wrapperPanel);
                };

            var Hide = 
                function()
                {
                    self.settingsPanel.RemoveClass('SettingsVisible');
                    self.visible = false;
                };

            var RetrieveTextBoxStates =
                function(state, type)
                {
                    for (var textBox in self.textBoxes)
                    {
                        if (self.textBoxes[textBox].type === type)
                        {
                            state[textBox] = self.textBoxes[textBox].panel.text;
                        }
                    }
                };

            var Show =
                function()
                {
                    if (!self.GetCreated())
                    {
                        CreatePanel();
                    }

                    if (modules.Utility.IsNull(self.isHost))
                    {
                        $.Schedule(0.1, Show);
                        return;
                    }

                    self.settingsPanel.AddClass('SettingsVisible');

                    ShowNav();
                    ShowContent();

                    self.visible = true;
                };

            var ShowContent =
                function()
                {
                    self.contentPanel.RemoveAndDeleteChildren();

                    var settings = self.groups[self.currentGroupIndex].settings;

                    for (var i = 0, iLength = settings.length; i < iLength; ++i)
                    {
                        var rowPanel = $.CreatePanel('Panel', self.contentPanel, '');
                        rowPanel.AddClass('SettingsContentRow');

                        var row = settings[i];

                        for (var j = 0, jLength = row.length; j < jLength; ++j)
                        {
                            var targetElementToolTip;

                            if (!modules.Utility.IsString(row[j].id) && row[j].type !== 'divider' && row[j].type !== 'header')
                            {
                                throw new Error('Each setting must have a unique ID in order to internally save data.');
                            }

                            var state = row[j].local ? self.state.local : self.state.host;
                            var disable = !row[j].local && !self.isHost;

                            switch (row[j].type)
                            {
                                case 'dropdown':
                                    var OnInputSubmit =
                                        function(id, state, dropDownPanel, options)
                                        {
                                            return function()
                                                {
                                                    for (var option in options)
                                                    {
                                                        if (options[option].id === dropDownPanel.GetSelected().id)
                                                        {
                                                            state[id] = options[option].value;
                                                        }
                                                    }
                                                };
                                        };

                                    var itemPanel = $.CreatePanel('Panel', rowPanel, row[j].id);
                                    itemPanel.BLoadLayout('file://{resources}/layout/custom_game/modules/dropdown.xml', false, false);

                                    var labelPanel = itemPanel.Children()[0];
                                    labelPanel.text = row[j].localize ? $.Localize(row[j].text) : row[j].text;

                                    var dropDownPanel = $.CreatePanel('DropDown', itemPanel.Children()[1], '');
                                    var options = row[j].options;
                                    var selected = null;

                                    for (var k = 0, kLength = options.length; k < kLength; ++k)
                                    {
                                        var dropDownOptionPanel = $.CreatePanel('Label', $.GetContextPanel(), options[k].id);
                                        dropDownOptionPanel.text = row[j].localize ? $.Localize(options[k].text) : options[k].text;

                                        dropDownPanel.AddOption(dropDownOptionPanel);

                                        if (options[k].id === row[j].default)
                                        {
                                            dropDownPanel.SetSelected(dropDownOptionPanel.id);
                                            dropDownPanel.Children()[0].text = dropDownOptionPanel.text;
                                            selected = options[k].value;
                                        }
                                    }

                                    dropDownPanel.SetPanelEvent('oninputsubmit', OnInputSubmit(row[j].id, state, dropDownPanel, options));

                                    state[row[j].id] = selected;

                                    targetElementToolTip = labelPanel;

                                    if (disable)
                                    {
                                        itemPanel.AddClass('SettingsContentItemDisabled');
                                        dropDownPanel.enabled = false;
                                    }

                                    break;

                                case 'checkbox':
                                    var OnActivate =
                                        function(id, state, checkBoxPanel)
                                        {
                                            return function()
                                                {
                                                    state[id] = checkBoxPanel.checked;
                                                };
                                        };

                                    var itemPanel = $.CreatePanel('Panel', rowPanel, row[j].id);
                                    itemPanel.BLoadLayout('file://{resources}/layout/custom_game/modules/checkbox.xml', false, false);

                                    var checkBoxPanel = itemPanel.Children()[0];
                                    checkBoxPanel.text = row[j].localize ? $.Localize(row[j].text) : row[j].text;
                                    checkBoxPanel.SetSelected(!!row[j].default);
                                    checkBoxPanel.SetPanelEvent('onactivate', OnActivate(row[j].id, state, checkBoxPanel));

                                    state[row[j].id] = checkBoxPanel.checked;

                                    targetElementToolTip = checkBoxPanel;

                                    if (disable)
                                    {
                                        checkBoxPanel.enabled = false;
                                    }

                                    break;

                                case 'radio':
                                    // RadioButton panels have absolutely no JS utility functions (no way of dynamically setting group).
                                    // Create our own logic for it.

                                    var OnActivate =
                                        function(state, id, radioButtonPanel, group, value)
                                        {
                                            return function()
                                                {
                                                    for (var radioButtonID in self.radioButtons[group])
                                                    {
                                                        if (self.radioButtons[group][radioButtonID] !== radioButtonPanel)
                                                        {
                                                            self.radioButtons[group][radioButtonID].RemoveClass('SettingsContentRadioButtonSelected');
                                                        }
                                                    }

                                                    radioButtonPanel.AddClass('SettingsContentRadioButtonSelected');
                                                    state[id] = value;
                                                };
                                        };

                                    var itemPanel = $.CreatePanel('Panel', rowPanel, row[j].id);
                                    itemPanel.BLoadLayout('file://{resources}/layout/custom_game/modules/radio.xml', false, false);
                                    itemPanel.Children()[0].text = row[j].text;

                                    self.radioButtons[row[j].group] = { };

                                    var options = row[j].options;
                                    var selected = null;

                                    for (var k = 0, kLength = options.length; k < kLength; ++k)
                                    {
                                        var radioButtonPanel = $.CreatePanel('Panel', itemPanel.Children()[1], options[k].id);
                                        radioButtonPanel.AddClass('SettingsContentRadioButton');

                                        var radioButtonInnerPanel = $.CreatePanel('Panel', radioButtonPanel, '');
                                        radioButtonInnerPanel.AddClass('SettingsContentRadioBox');

                                        var radioButtonLabelPanel = $.CreatePanel('Label', radioButtonPanel, '');
                                        radioButtonLabelPanel.text = options[k].text;

                                        self.radioButtons[row[j].group][options[k].id] = radioButtonPanel;

                                        if (!disable)
                                        {
                                            radioButtonPanel.SetPanelEvent('onactivate', OnActivate(state, row[j].id, radioButtonPanel, row[j].group, options[k].value));
                                        }

                                        if (options[k].id === row[j].default)
                                        {
                                            selected = options[k].value;
                                            radioButtonPanel.AddClass('SettingsContentRadioButtonSelected');
                                        }
                                    }

                                    state[row[j].id] = selected;

                                    targetElementToolTip = itemPanel.Children()[0];

                                    if (disable)
                                    {
                                        itemPanel.AddClass('SettingsContentItemDisabled');
                                    }

                                    break;

                                case 'textbox':
                                    var itemPanel = $.CreatePanel('Panel', rowPanel, row[j].id);
                                    itemPanel.BLoadLayout('file://{resources}/layout/custom_game/modules/textbox.xml', false, false);
                                    itemPanel.Children()[0].text = row[j].text;

                                    var textEntryPanel = itemPanel.Children()[1].Children()[0];
                                    textEntryPanel.SetMaxChars(row[j].maxChars || 50);
                                    textEntryPanel.text = row[j].default || '';

                                    self.textBoxes[row[j].id] =
                                        {
                                            type: row[j].local ? 'local' : 'host',
                                            panel: textEntryPanel
                                        };
                                    state[row[j].id] = textEntryPanel.text;

                                    targetElementToolTip = itemPanel.Children()[0];

                                    if (disable)
                                    {
                                        itemPanel.AddClass('SettingsContentItemDisabled');
                                        textEntryPanel.enabled = false;
                                    }

                                    break;

                                case 'header':
                                    var headerPanel = $.CreatePanel('Panel', rowPanel, '');
                                    headerPanel.AddClass('SettingsContentHeader');

                                    var headerLabelPanel = $.CreatePanel('Label', headerPanel, '');
                                    headerLabelPanel.text = row[j].title;

                                    break;

                                case 'divider':
                                    rowPanel.AddClass('SettingsContentRowDivider');
                                    break;

                                default:
                                    throw new Error('Unsupported setting type found while rendering content.');
                                    break;
                            }

                            if (row[j].toolTipText || row[j].toolTipTitle)
                            {
                                var toolTip = new modules.ToolTip();
                                toolTip.SetTargetElement(targetElementToolTip);
                                toolTip.SetText(row[j].toolTipText || '', row[j].localize);
                                toolTip.SetTitle(row[j].toolTipTitle || '', row[j].localize);
                                toolTip.SetPlacement(row[j].toolTipPlacement || 'right');
                                toolTip.SetEnabled(true);
                            }
                        }
                    }
                };

            var ShowNav =
                function()
                {
                    var OnActivate =
                        function(id)
                        {
                            return function()
                                {
                                    self.SetCurrentGroup(id);
                                };
                        };

                    for (var i = 0, iLength = self.groups.length; i < iLength; ++i)
                    {
                        if (!self.groups[i].navPanel)
                        {
                            self.groups[i].navPanel = $.CreatePanel('Panel', self.navPanel, self.groups[i].id);
                            self.groups[i].navPanel.BLoadLayout('file://{resources}/layout/custom_game/modules/navbutton.xml', false, false);
                            self.groups[i].navPanel.SetPanelEvent('onactivate', OnActivate(self.groups[i].navPanel.id));
                        }

                        var buttonPanel = self.groups[i].navPanel.Children()[0];
                        buttonPanel.Children()[0].text = self.groups[i].localize ? $.Localize(self.groups[i].title) : self.groups[i].title;

                        if (self.currentGroupIndex === i)
                        {
                            buttonPanel.AddClass('SettingsActive');
                            buttonPanel.RemoveClass('SettingsInactive');
                        }
                        else
                        {
                            buttonPanel.AddClass('SettingsInactive');
                            buttonPanel.RemoveClass('SettingsActive');
                        }
                    }
                };

            var ValidateGroup =
                function(groupData)
                {
                    if (!modules.Utility.IsObject(groupData))
                    {
                        throw new Error('Group must be an object.');
                    }

                    if (!modules.Utility.IsString(groupData.id))
                    {
                        throw new Error('Group property "id" must be a unique string.');
                    }

                    for (var i = 0, iLength = self.groups.length; i < iLength; ++i)
                    {
                        if (self.groups[i].id === groupData.id)
                        {
                            throw new Error('Group property "id" must be unique.');
                        }
                    }

                    groupData.localize = groupData.localize || false;
                    groupData.title = groupData.title || 'SettingsGroup Title';
                };

            DetermineIfHost();

            // Interface methods.

            this.GetCreated =
                function()
                {
                    return !!this.settingsPanel;
                };

            this.GetCurrentGroup =
                function()
                {
                    return this.currentGroupID;
                };

            this.GetHostState =
                function()
                {
                    RetrieveTextBoxStates(this.state.host, 'host');

                    return this.state.host;
                };

            this.GetLocalState =
                function()
                {
                    RetrieveTextBoxStates(this.state.local, 'local');

                    return this.state.local;
                };

            this.GetVisible =
                function()
                {
                    return this.visible;
                };

            this.RegisterGroup =
                function(groupData)
                {
                    ValidateGroup(groupData);
                    this.groups.push(groupData);

                    if (!this.currentGroupID)
                    {
                        this.currentGroupID = groupData.id;
                        this.currentGroupIndex = this.groups.length - 1;
                    }
                };

            this.SetCurrentGroup =
                function(id)
                {
                    ChangeGroup(id);
                };

            this.SetVisible =
                function(visible)
                {
                    if (visible)
                    {
                        if (!this.visible)
                        {
                            Show();
                        }
                    }
                    else if (this.visible)
                    {
                        Hide();
                    }
                };

            this.SetWrapper =
                function(wrapperPanel)
                {
                    var setWrapper = !!this.wrapperPanel;
                    this.wrapperPanel = wrapperPanel;

                    if (setWrapper)
                    {
                        SetWrapper();
                    }
                };
        }

        modules.Settings = Settings;
    })();
