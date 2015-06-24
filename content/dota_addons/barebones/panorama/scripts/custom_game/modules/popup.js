'use strict';

// Apply at least some form of namespace. 
// Note that this PopUp module requires the Utility module.

var modules = modules || { };

(
    function()
    {
        // Class definition.

        function PopUp(options)
        {
            if (!modules.Utility.IsObject(options))
            {
                options = { };
            }

            // Internal data.

            var self = this;

            this.closeable = options.closeable || true;
            this.closePanel = null;
            this.layout = options.layout || null;
            this.popUpPanel = null;
            this.text = options.text || 'PopUp Text';
            this.textLocalized = options.localize || false;
            this.visible = false;

            // Internal methods.

            var CreatePanel =
                function()
                {
                    self.popUpPanel = $.CreatePanel('Panel', $.GetContextPanel(), '');
                    self.popUpPanel.BLoadLayout('file://{resources}/layout/custom_game/modules/popup.xml', false, false);
                };

            var Hide =
                function()
                {
                    self.popUpPanel.RemoveClass('SettingsPopUpVisible');
                    
                    if (self.closePanel)
                    {
                        self.closePanel.ClearPanelEvent('onactivate');
                    }

                    self.visible = false;
                };

            var OnActivate =
                function()
                {
                    Hide();
                };

            var SetCloseable =
                function()
                {
                    if (self.closeable)
                    {
                        if (!self.closePanel)
                        {
                            self.closePanel = $.CreatePanel('Button', self.popUpPanel, 'SettingsPopUpCloseButton');
                        }

                        self.closePanel.SetPanelEvent('onactivate', OnActivate);
                    }
                    else if (self.closePanel)
                    {
                        self.closePanel.DeleteAsync(0);
                    }
                };

            var SetContent =
                function()
                {
                    var containerPanel = self.popUpPanel.Children()[0];

                    containerPanel.RemoveAndDeleteChildren();

                    if (self.layout)
                    {
                        var layoutPanel = $.CreatePanel('Panel', containerPanel, '');
                        layoutPanel.BLoadLayout(self.layout, false, false);
                    }
                    else
                    {
                        var labelPanel = $.CreatePanel('Label', containerPanel, '');
                        labelPanel.text = self.textLocalized ? $.Localize(self.text) : self.text;
                    }

                    SetCloseable();
                };

            var Show =
                function()
                {
                    if (!self.GetCreated())
                    {
                        CreatePanel();
                    }

                    SetContent();

                    self.popUpPanel.AddClass('SettingsPopUpVisible');
                    self.visible = true;
                };

            // Interface methods.

            this.GetCloseable =
                function()
                {
                    return this.closeable;
                };

            this.GetCreated =
                function()
                {
                    return !!this.popUpPanel;
                };

            this.GetLayout =
                function()
                {
                    return this.layout;
                };

            this.GetVisible =
                function()
                {
                    return this.visible;
                };

            this.SetCloseable =
                function(closeable)
                {
                    this.closeable = closeable;

                    if (this.GetVisible())
                    {
                        SetCloseable();
                    }
                };

            this.SetLayout =
                function(layout)
                {
                    this.layout = layout;

                    if (this.GetVisible())
                    {
                        Show();
                    }
                };

            this.SetText =
                function(text, localize)
                {
                    this.text = text;
                    this.textLocalized = !!localize;

                    if (this.GetVisible() && !this.layout)
                    {
                        SetText();
                    }
                };

            this.SetVisible =
                function(visible)
                {
                    if (visible)
                    {
                        if (!this.GetVisible())
                        {
                            Show();
                        }
                    }
                    else if (this.GetVisible())
                    {
                        Hide();
                    }
                };
        }

        modules.PopUp = PopUp;
    })();
