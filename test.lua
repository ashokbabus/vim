--CertApp Parser
--Author : Ashok Babu Shanmugam <xrpq48@motorolasolutions.com>
--CopyRight:2014,MotorolaSolutions.com

require('LuaXml')

local xfile = xml.load("test.xml")

if arg[1] == nil then
	local xoperation=xfile:find("operation")
	local op_indx = 1
	while xoperation[op_indx] ~= nil do
		print("\t" .. xoperation[op_indx].name)
		op_indx = op_indx + 1
	end
end


local xscene = xfile:find(arg[1])

if xscene ~= nil and (arg[1] == "reada" or arg[1] == "writea" ) then
  local i=1;
  local k=2;
  while xscene[i] ~=nil do
	  if  ( arg[k] ~= nil) and ((string.find(arg[k],"--",1,2) and xscene[i].name == arg[k]) or
		  (string.find(arg[k],"-",1,1) and xscene[i].sname == arg[k])) then
		 if arg[k + 1] == nil then
		  	print(xscene[i].help)
		  	print("Range=" .. xscene[i].range)
	 	 	print("Default=" .. xscene[i].default)	
		 else
			print("You Entered : ", arg[k + 1])
			k = k + 2
		end
	  else
		io.write(xscene[i].sname .. "|" .. xscene[i].name .. " <" .. xscene[i].type .. ">,")
	end
	  i = i + 1
  end
  io.write("\n")
end

if xscene ~= nil and (arg[1] == "seta" or arg[1] == "geta" ) then
  local i=1
  
  while xscene[i] ~=nil do
	  if  ( arg[2] ~= nil) and (xscene[i].name == arg[2] or (string.find(arg[2],"-",1,1) and xscene[i].sname == arg[2])) then
		 xparams=xscene[i]:find(xscene[i].name)
		 if xparams == nil then
			 print("null, not found")
			 break
		 end
		 local j=1
		 local k=3
		 while xparams[j] ~= nil do
			 if  ( arg[k] ~= nil) and ((string.find(arg[k],"--",1,2) and xparams[j].name == arg[k]) or
				 (string.find(arg[k],"-",1,1) and xparams[j].sname == arg[k])) then
				 if arg[k + 1] == nil then
					 io.write("\t" .. xparams[j].name .. " : " .. xparams[j].help)
					 io.write(". Range=" .. xparams[j].range)
					 io.write(". Default=" .. xparams[j].default .. "\n")	
				 else
					 print("You Entered : ", arg[k + 1])
					 k = k + 2
				 end
			 else
				io.write(xparams[j].sname .. "|" .. xparams[j].name .. " <" .. xparams[j].type .. ">,")
			 end
			 j = j + 1
		end
		break
	  else
		io.write(xscene[i].sname .. "|" .. xscene[i].name .. ", ")
	end
	  i = i + 1
  end
  io.write("\n")
end

parse_xmltable = function (xparse, arg_index) 
	local i = 1
	local k = arg_index
	local match_found=0
	while xparse[i] ~= nil do
		if  ( arg[k] ~= nil) and ((string.find(arg[k],"--",1,2) and xparse[i].name == arg[k]) or
			(string.find(arg[k],"-",1,1) and xparse[i].sname == arg[k])) then
			if xparse[i].type == "table" then
				--parse_xmltable(xparse:find(xparse[i].name), arg_index + 1)
				parse_xmltable(xparse[i], arg_index + 1)
			elseif xparse[i].type == "params" then
				--parse_xmlparams(xparse[i]:find(xparse[i].name), arg_index)
				parse_xmlparams(xparse[i], arg_index + 1)
			end
			match_found = 1
			break
		elseif arg[k] == nil then
			--May revisit this condition
			--io.write(xparse[i].sname .. "|" .. xparse[i].name .. " <" .. xparse[i].type .. ">, ")
		end
		i = i + 1
	end
	if match_found == 0 then
		i=1
		while xparse[i] ~= nil do
			io.write(xparse[i].sname .. "|" .. xparse[i].name .. " <" .. xparse[i].type .. ">, ")
			i = i + 1
		end
	end
end

parse_xmlparams = function (xparams, arg_index) 
	local j=1
	local k=arg_index
	--local match_found=0
	while xparams[j] ~= nil do
		if  ( arg[k] ~= nil) and ((string.find(arg[k],"--",1,2) and xparams[j].name == arg[k]) or
			(string.find(arg[k],"-",1,1) and xparams[j].sname == arg[k])) then
			--match_found=1
			if arg[k + 1] == nil then
				io.write("\t" .. xparams[j].name .. " : " .. xparams[j].help)
				io.write(". Range=" .. xparams[j].range)
				io.write(". Default=" .. xparams[j].default .. "\n")	
				break
			else
				print("You Entered : ", arg[k + 1])
				k = k + 2
			end
		else
			io.write(xparams[j].sname .. "|" .. xparams[j].name .. " <" .. xparams[j].type .. ">, ")
		end
		j = j + 1
	end
	--if match_found == 0 then
	--	j=1
	--	while xparams[j] ~= nil do
	--		io.write(xparams[j].sname .. "|" .. xparams[j].name .. " <" .. xparams[j].type .. ">, ")
	--		j = j + 1
	--	end
	--end
end

if xscene ~= nil and (arg[1] == "load" or arg[1] == "read" or arg[1] == "set" ) then
  local i=1
  local k=2
  local match_found=0
  local simplified=0
  while xscene[i] ~=nil do
	  if  ( arg[k] ~= nil) and (xscene[i].name == arg[k] or (string.find(arg[k],"-",1,1) and xscene[i].sname == arg[k])) then
		  match_found=1
		  if xscene[i].type == "table" then
			  parse_xmltable(xscene[i]:find(xscene[i].name), k + 1)
	--		  break
		  elseif xscene[i].type == "params" then
			  parse_xmlparams(xscene[i]:find(xscene[i].name), k + 1)
			  break
		  else
			  if arg[k + 1] == nil then
				  io.write("\t" .. xscene[i].name .. " : " .. xscene[i].help)
				  io.write(". Range=" .. xscene[i].range)
				  io.write(". Default=" .. xscene[i].default .. "\n")	
				  break
			  else
				  print("You Entered : ", arg[k + 1])
				  k = k + 2
			  end
		  end

	  elseif  not ( xscene[i].type == "table" or xscene[i].type == "params" ) then
	  --else 
	  	simplified = 1
		io.write(xscene[i].sname .. "|" .. xscene[i].name .. ", ")
	end
	  i = i + 1
  end
	if match_found == 0 and simplified == 0 then
		i=1
  		while xscene[i] ~=nil do
			io.write(xscene[i].sname .. "|" .. xscene[i].name .. ", ")
			i = i + 1
		end
	end
  io.write("\n")
end

xfile:save"t.xml"
