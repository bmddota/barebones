'use strict';

// Apply at least some form of namespace. 

var modules = modules || { };

(
    function()
    {
        var Utility = { };

        // Panorama specific.

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

        // Non-panorama specific.

        Utility.GetType =
            function(variable)
            {
                return Object.prototype.toString.call(variable).match(/\s([a-zA-Z]+)/)[1].toLowerCase();
            };

        Utility.IsArray =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Array]';
            };

        Utility.IsBoolean =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Boolean]';
            };
        
        Utility.IsDate =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Date]';
            };

        Utility.IsFunction =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Function]';
            };

        Utility.IsNull =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Null]';
            };

        Utility.IsNumber =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Number]';
            };

        Utility.IsObject =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Object]';
            };

        Utility.IsRegExp =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object RegExp]';
            };

        Utility.IsString =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object String]';
            };
        
        Utility.IsUndefined =
            function(variable)
            {
                return Object.prototype.toString.call(variable) === '[object Undefined]';
            };
        
        Utility.MergeObjects =
            function(object1, object2)
            {
                var object3;

                if (Object.keys(object1).length)
                {
                    object3 = Utility.MergeObjects({ }, object1);
                }
                else
                {
                    object3 =  { };
                }

                for (var property in object2)
                {
                    try
                    {
                        if (object2[property].constructor === Object)
                        {
                            if (Object.keys(object2[property]).length === 0)
                            {
                                object3[property] = { };
                            }
                            else
                            {
                                object3[property] = Utility.MergeObjects(object3[property], object2[property]);
                            }
                        }
                        else
                        {
                            object3[property] = object2[property];
                        }
                    }
                    catch (e)
                    {
                        object3[property] = object2[property];
                    }
                }

                return object3;
            };

        modules.Utility = Utility;
    })();
