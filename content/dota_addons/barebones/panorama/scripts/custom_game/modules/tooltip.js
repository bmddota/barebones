'use strict';

// Apply at least some form of namespace. 
// Note that this ToolTip module requires the modules.Utility module.

var modules = modules || { };

(
    function()
    {
        // Class definition.

        function ToolTip(options)
        {
            if (!modules.Utility.IsObject(options))
            {
                options = { };
            }

            // Internal data.

            var self = this;

            this.enabled = false;
            this.localize = options.localize || false;
            this.placement = options.placement || 'right';
            this.targetElement = options.targetElement || null;
            this.text = options.text || 'ToolTip Text';
            this.title = options.title || 'Title';
            this.titlePanel = null;
            this.toolTipPanel = null;
            this.visible = false;

            // Internal methods.

            var CreatePanel =
                function()
                {
                    self.toolTipPanel = $.CreatePanel('Panel', $.GetContextPanel(), '');
                    self.toolTipPanel.BLoadLayout('file://{resources}/layout/custom_game/modules/tooltip.xml', false, false);
                    SetText();
                };

            var HandlePlacement =
                function(position, overridePlacement)
                {
                    var placement = overridePlacement || self.placement;

                    switch (placement)
                    {
                        case 'bottom':
                            var newY = position.y + self.targetElement.actuallayoutheight;
                            
                            if (IsValidPosition(position.x, newY))
                            {
                                position.y = newY;
                                self.toolTipPanel.AddClass('SettingsToolTipTopArrowVisible');
                            }
                            else
                            {
                                HandlePlacement(position, 'left');
                            }

                            break;

                        case 'left':
                            var newX = position.x - self.toolTipPanel.actuallayoutwidth;
                            var newY = position.y - 15 + Math.floor(self.targetElement.actuallayoutheight / 2);

                            if (IsValidPosition(newX, newY))
                            {
                                position.x = newX;
                                position.y = newY;
                                self.toolTipPanel.AddClass('SettingsToolTipRightArrowVisible');
                            }
                            else
                            {
                                HandlePlacement(position, 'right');
                            }

                            break;

                        case 'right':
                            var newX = position.x + self.targetElement.actuallayoutwidth;
                            var newY = position.y - 15 + Math.floor(self.targetElement.actuallayoutheight / 2);

                            if (IsValidPosition(newX, newY))
                            {
                                position.x = newX;
                                position.y = newY;
                                self.toolTipPanel.AddClass('SettingsToolTipLeftArrowVisible');
                            }
                            else
                            {
                                HandlePlacement(position, 'top');
                            }

                            break;

                        case 'top':
                            position.y -= self.toolTipPanel.actuallayoutheight;
                            self.toolTipPanel.AddClass('SettingsToolTipBottomArrowVisible');

                            break;

                        default:
                            throw new Error('Invalid placement was given.');
                            break;
                    }
                };

            var IsValidPosition =
                function(x, y)
                {
                    if (x < 0 ||
                        (x + self.toolTipPanel.actuallayoutwidth) > $.GetContextPanel().actuallayoutwidth ||
                        y < 0 ||
                        (y + self.toolTipPanel.actuallayoutheight) > $.GetContextPanel().actuallayoutheight)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                };

            var OnMouseOut =
                function()
                {
                    self.toolTipPanel.RemoveClass('SettingsToolTipVisible');
                    self.visible = false;
                };

            var OnMouseOver =
                function()
                {
                    var position = modules.Utility.GetAbsoluteOffsets(self.targetElement);

                    HandlePlacement(position);

                    self.toolTipPanel.style.transform = 'translate3d(' + position.x + 'px, ' + position.y + 'px, 0px);';
                    self.toolTipPanel.AddClass('SettingsToolTipVisible');
                    self.visible = true;
                };

            var Enable =
                function()
                {
                    if (!self.GetCreated())
                    {
                        CreatePanel();
                    }

                    self.targetElement.SetPanelEvent('onmouseout', OnMouseOut);
                    self.targetElement.SetPanelEvent('onmouseover', OnMouseOver);

                    self.enabled = true;
                };

            var SetText =
                function()
                {
                    self.toolTipPanel.Children()[1].Children()[1].Children()[0].text = self.localize ? $.Localize(self.text) : self.text;

                    if (self.title)
                    {
                        if (!self.titlePanel)
                        {
                            self.titlePanel = $.CreatePanel('Label', self.toolTipPanel.Children()[1].Children()[1], '');
                            self.titlePanel.AddClass('SettingsToolTipTitle');
                            self.toolTipPanel.Children()[1].Children()[1].MoveChildBefore(self.titlePanel, self.toolTipPanel.Children()[1].Children()[1].Children()[0]);
                        }

                        self.titlePanel.text = self.localize ? $.Localize(self.title) : self.title;
                    }
                    else if (self.titlePanel)
                    {
                        self.titlePanel.DeleteAsync(0);
                    }
                };

            var Disable =
                function()
                {
                    self.targetElement.ClearPanelEvent('onmouseout');
                    self.targetElement.ClearPanelEvent('onmouseover');

                    OnMouseOut();

                    self.enabled = false;
                };

            // Interface methods.

            this.GetCreated =
                function()
                {
                    return !!this.toolTipPanel;
                };

            this.GetEnabled =
                function()
                {
                    return this.enabled;
                };

            this.GetText =
                function()
                {
                    return this.text;
                };

            this.GetTitle =
                function()
                {
                    return this.title;
                };

            this.GetVisible =
                function()
                {
                    return this.visible;
                };

            this.Reset = 
                function()
                {
                    if (this.GetEnabled())
                    {
                        Disable();
                    }

                    Enable();
                };

            this.SetEnabled =
                function(enable)
                {
                    if (enable)
                    {
                        if (!this.GetEnabled())
                        {
                            Enable();
                        }
                    }
                    else if (this.GetEnabled())
                    {
                        Disable();
                    }
                };

            this.SetPlacement =
                function(placement)
                {
                    this.placement = placement;
                };

            this.SetTargetElement =
                function(targetElement)
                {
                    var enable = false;

                    if (this.GetEnabled())
                    {
                        Disable();
                        enable = true;
                    }

                    this.targetElement = targetElement;

                    if (enable)
                    {
                        Enable();
                    }
                };

            this.SetText =
                function(text, localize)
                {
                    this.text = text;
                    this.localize = !!localize;

                    if (this.GetCreated())
                    {
                        SetText();
                    }
                };

            this.SetTitle =
                function(title, localize)
                {
                    this.title = title;
                    this.localize = !!localize;

                    if (this.GetCreated())
                    {
                        SetText();
                    }
                };
        }

        modules.ToolTip = ToolTip;
    })();
