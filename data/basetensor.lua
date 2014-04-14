-----------------------------------------------------------------------
--[[ BaseTensor ]]-- 
-- Abstract class
-- Adapter (design pattern) for torch.Tensor 
------------------------------------------------------------------------
local BaseTensor = torch.class("dp.BaseTensor")
BaseTensor.isBaseTensor = true

-- Returns number of samples
function BaseTensor:nSample()
   error"Not Implemented"
end

--Decorator/Adapter for torch.Tensor
--Returns a batch of data. 
--Note that the batch uses different storage (because of :index())
function BaseTensor:index(indices)
   error"Not Implemented"
end

function BaseTensor:sub(start, stop)
   error"Not Implemented"
end

-- return iterator over components
function BaseTensor:pairs()
   error"Not Implemented"
end

-- copy data into existing memory allocated for data
function BaseTensor:copy(basetensor)
   error"Not Implemented"
end

-- return a clone without data 
function BaseTensor:emptyClone()
   error"Not Implemented"
end

---- static methods ----
function BaseTensor.transpose(axis, new_dim, axes, size, data)
   -- copy
   axes = _.omit(axes)
   local current_dim = _.indexOf(axes, axis)
   if current_dim == 0 then
      error("Axis " .. axis .. 'is not in axes ' .. axes)
   end
   if new_dim < 0 then
      new_dim = #axes + 1 - new_dim
   end
   if current_dim ~= new_dim then
      axes[current_dim] = axes[new_dim]
      axes[new_dim] = axis
      local new_size = size[new_dim]
      size[new_dim] = size[current_dim]
      size[current_dim] = new_size
      if data then
         data = data:transpose(new_dim, current_dim)
      end
   end
   return axes, size, data
end

--returns true if all indices in obj_table are instances of BaseTensor
--else return false and index of first non-element
function BaseTensor.areInstances(obj_table)
   local map = _.map(obj_table, function(obj) return obj.isBaseTensor end)
   return _.all(map), _.indexOf(map, false)
end

function BaseTensor.assertInstances(obj_table)
   local areInstances, index = BaseTensor.areInstances(obj_table)
   assert(areInstances, "Error : object at index " .. index .. 
      " is of wrong type. Expecting type dp.DataTensor.")
end
