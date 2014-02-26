local pairs, setmetatable, getmetatable, table =
      pairs, setmetatable, getmetatable, table
module('dom')

function shallowcopy(orig)
    local new = {}
    for k, v in pairs(orig) do
        new[k] = v
    end
    return new
end

Node = {ELEMENT_NODE=1, ATTRIBUTE_NODE=2, TEXT_NODE=3, CDATA_SECTION_NODE=4, ENTITY_REFERENCE_NODE=5,
        ENTITY_NODE=6, PROCESSING_INSTRUCTION_NODE=7, COMMENT_NODE=8, DOCUMENT_NODE=9, DOCUMENT_TYPE_NODE=10,
        DOCUMENT_FRAGMENT_NODE=11, NOTATION_NODE=12}
Node.__index = Node

function Node.new(doc)
    local instance = {ownerDocument=doc}
    setmetatable(instance, Node)
    return instance
end

function Node:insertBefore(new_child, ref_child)
    if new_child.nodeType == Node.DOCUMENT_FRAGMENT_NODE then
        for _, child in new_child.childNodes do
            self:insertBefore(child, ref_child)
        end
        return
    end

    if new_child.parentNode then new_child.parentNode.removeChild(new_child) end
    if ref_child == nil then return self:appendChild(new_child) end
    
    local insert_index = nil
    for i, child in ipairs(self.childNodes) do
        if child == ref_child then
            insert_index = i
            break
        end
    end
    
    if insert_index > 1 then
        ref_child.previousSibling.nextSibling = new_child
    end
    ref_child.previousSibling = new_child
    
    new_child.parentNode = self
    new_child:switchDocument(self.ownerDocument)
    table.insert(self, insert_index, new_child)
    self:resetChildReferences()
    return new_child
end

function Node:replaceChild(new_child, old_child)
    new_child = self:insertBefore(new_child, old_child)
    self:removeChild(old_child)
    return new_child
end

function Node:removeChild(old_child)
    if old_child.previousSibling ~= nil then old_child.previousSibling.nextSibling = old_child.nextSibling end
    if old_child.nextSibling ~= nil then old_child.nextSibling.previousSibling = old_child.previousSibling end
    
    local my_index = nil
    for i, child in ipairs(self.childNodes) do
        if child == old_child then
            my_index = i
            break
        end
    end
    
    table.remove(self.childNodes, my_index)
    
    old_child.parentNode = nil
    old_child.nextSibling = nil
    old_child.previousSibling = nil
    
    self:resetChildReferences()
    return old_child
end

function Node:appendChild(new_child)
    if new_child.nodeType == Node.DOCUMENT_FRAGMENT_NODE then
        for _, child in new_child.childNodes do
            self:appendChild(child)
        end
        return
    end

    if new_child.parentNode ~= nil then new_child.parentNode.removeChild(new_child) end
    
    new_child.parentNode = self
    new_child:switchDocument(self.ownerDocument)
    if #self.childNodes > 0 then
        new_child.previousSibling = self.childNodes[#self.childNodes]
    end
    self.childNodes[#self.childNodes + 1] = new_child
    
    self:resetChildReferences()
    return new_child
end

function Node:hasChildNodes()
    return #self.childNodes > 0
end

function Node:cloneNode(deep)
    local new_node = shallowcopy(self)
    setmetatable(new_node, getmetatable(self))
    new_node.childNodes = {}
    new_node.parentNode = nil
    new_node.previousSibling = nil
    new_noe.nextSibling = nil
    
    if deep then
        for i, deep_child in ipairs(self.childNodes) do
            new_node.childNodes[i] = deep_child.cloneNode(deep)
        end
    end
    
    return new_node
end

function Node:switchDocument(new_doc)
    if new_doc == self.ownerDocument then return nil end
    
    self.ownerDocument = new_doc
    for _, child in ipairs(self.childNodes) do
        child:switchDocument(new_doc)
    end
end

function Node:resetChildReferences()
    if #self.childNodes > 0 then
        self.firstChild = self.childNodes[1]
        self.lastChild = self.childNodes[#self.childNodes]
    end
end

Attr = shallowcopy(Node)
Attr.__index = Attr
function Attr.new(name, value, doc)
    instance = {name=name, nodeName=name, value=value, nodeValue=value, specified=true, nodeType=Node.ATTRIBUTE_NODE, ownerDocument=doc}
    setmetatable(instance, Attr)
    return instance
end

CharacterData = shallowcopy(Node)
CharacterData.__index = CharacterData
function CharacterData.new(data, doc)
    local instance = {data=data, ownerDocument=doc, length=#data}
    setmetatable(instance, CharacterData)
    return instance
end

function CharacterData:substringData(offset, count)
    return self.data:sub(offset, offset + count)
end

function CharacterData:appendData(arg)
    self.data = self.data .. arg
    self.length = #self.data
end

function CharacterData:insertData(offset, arg)
    self.data = self.data:sub(1, offset) .. arg .. self.data:sub(offset + 1)
    self.length = #self.data
end

function CharacterData:deleteData(offset, count)
    self.data = self.data:sub(1, offset) .. self.data:sub(offset + count)
    self.length = #self.data
end

function CharacterData:replaceData(offset, count, arg)
    self:deleteData(offset, count)
    self:insertData(offset, arg)
end

Text = shallowcopy(CharacterData)
Text.__index = Text
function Text.new(data, doc)
    local instance = {nodeType=Node.TEXT_NODE, nodeName='#text', nodeValue=data, data=data, length=#data, ownerDocument=doc}
    setmetatable(instance, Text)
    return instance
end

function Text:splitText(offset)
    local sib1 = Text.new(self.data:sub(1, offset - 1), self.ownerDocument)
    local sib2 = Text.new(self.data:sub(offset), self.ownerDocument)
    self.parentNode.insertBefore(sib1, self)
    self.parentNode.insertBefore(sib2, self)
    self.parentNode.removeChild(self)
end

Comment = shallowcopy(CharacterData)
Comment.__index = Comment
function Comment.new(data, doc)
    local instance = {nodeType=Node.COMMENT_NODE, nodeName='#comment', nodeValue=data, data=data, length=#data, ownerDocument=doc}
    setmetatable(instance, Comment)
    return instance
end

ProcessingInstruction = shallowcopy(Node)
ProcessingInstruction.__index = ProcessingInstruction
function ProcessingInstruction.new(target, data, doc)
    local instance = {nodeType=Node.PROCESSING_INSTRUCTION_NODE, nodeName=target, nodeValue=data, data=data, ownerDocument=doc}
    setmetatable(instance, ProcessingInstruction)
    return instance
end

CDATASection = shallowcopy(Text)
CDATASection.__index = CDATASection
function CDATASection.new(data, doc)
    local instance = {nodeType=Node.CDATA_SECTION_NODE, nodeName='#cdata-section', nodeValue=data, data=data, length=#data, ownerDocument=doc}
    setmetatable(instance, CDATASection)
    return instance
end

Element = shallowcopy(Node)
Element.__index = Element
function Element.new(tag_name, doc)
    tag_name = tag_name:lower()
    local instance = {tagName=tag_name, nodeName=tag_name, nodeType=Node.ELEMENT_NODE, childNodes={}, attributes={}, ownerDocument=doc}
    setmetatable(instance, Element)
    return instance
end

function Element:getAttribute(name)
    return self.attributes[name]
end

function Element:setAttribute(name, value)
    self.attributes[name] = value
end

function Element:removeAttribute(name)
    self.attributes[name] = nil
end

function Element:getAttributeNode(name)
    if self.attributes[name] == nil then
        return nil
    else
        return Attr.new(name, self.attributes[name], self.ownerDocument)
    end
end

function Element:setAttributeNode(new_attr)
    self.attributes[new_attr.name] = new_attr.value
end

function Element:removeAttributeNode(old_attr)
    self.attributes[old_attr.name] = nil
end

function Element:getElementsByTagName(name, matches)
    name = name:lower() or '*'
    matches = matches or {}
    for _, child in ipairs(self.childNodes) do
        if child.nodeType == Node.ELEMENT_NODE then
            if name == '*' or child.tagName == name then
                matches[#matches + 1] = child
            end
            
            child:getElementsByTagName(name, matches)
        end
    end
    
    return matches
end

function Element:normalize()
    local to_remove = {}
    for i=#self.childNodes,1,-1 do
        local child = self.childNodes[i]
        if child.nodeType == Node.TEXT_NODE and child.previousSibling.nodeType == Node.TEXT_NODE then
            child.previousSibling.appendData(child.data)
            to_remove[#to_remove + 1] = child
        end
    end
    
    for _, normalized in ipairs(to_remove) do
        self.removeChild(normalized)
    end
end

DocumentFragment = shallowcopy(Node)
DocumentFragment.__index = DocumentFragment
function DocumentFragment.new(doc)
    local instance = {nodeType=Node.DOCUMENT_FRAGMENT_NODE, nodeName='#document-fragment', childNodes={}, ownerDocument=doc}
    setmetatable(instance, DocumentFragment)
    return instance
end

Document = shallowcopy(Node)
Document.__index = Document
function Document.new()
    local instance = {nodeName='#document', nodeType=Node.DOCUMENT_NODE, childNodes={}}
    setmetatable(instance, Document)
    return instance
end

function Document:createElement(tag_name)
    return Element.new(tag_name, self)
end

function Document:createDocumentFragment()
    return DocumentFragment.new(self)
end

function Document:createTextNode(data)
    return Text.new(data, self)
end

function Document:createComment(data)
    return Comment.new(data, self)
end

function Document:createCDATASection(data)
    return CDATASection.new(data, self)
end

function Document:createProcessingInstruction(target, data)
    return ProcessingInstruction.new(target, data, self)
end

function Document:createAttribute(name)
    return Attribute.new(name, nil, self)
end

function Document:createEntityReference(name)
end

Document.getElementsByTagName = Element.getElementsByTagName
