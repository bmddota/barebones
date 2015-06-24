'use strict';

// Apply at least some form of namespace. 

var modules = modules || { };

(
    function()
    {
        var Utility = { };

        Utility.GetAbsoluteOffsets =
            function(element, position)
            {
                if (!position)
                {
                    position =
                        {
                            x: 0,
                            y: 0
                        };
                }

                if (element !== $.GetContextPanel())
                {
                    position.x += element.actualxoffset;
                    position.y += element.actualyoffset;

                    return Utility.GetAbsoluteOffsets(element.GetParent(), position);
                }

                return position;
            };

        Utility.IsObject =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Object]';
            };

        modules.Utility = Utility;
    })();
