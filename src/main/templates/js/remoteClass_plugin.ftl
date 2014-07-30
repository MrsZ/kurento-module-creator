<#include "macros.ftm" >
<#assign module_name=module.name>
<#assign module_namespace>
  <#lt>${module_name}<#if remoteClass.abstract>/abstracts</#if><#rt>
</#assign>
<#assign remoteClass_namepath>
  <#lt>${module_namespace}.${remoteClass.name}<#rt>
</#assign>
<#assign extends_name>
  <#if remoteClass.name=="MediaObject">
    <#lt>EventEmitter<#rt>
  <#elseif remoteClass.extends??>
    <#lt>${remoteClass.extends.name}<#rt>
  </#if>
</#assign>
<#assign import_name>
  <#if remoteClass.extends??>
    <#list module.imports as import>
      <#list import.module.remoteClasses as remoteClass>
        <#if remoteClass.name == extends_name>
          <#lt>${import.name}<#rt>
          <#break>
        </#if>
      </#list>
    </#list>
  </#if>
</#assign>
<#if import_name == ''>
  <#list module.remoteClasses as remoteClass>
    <#if remoteClass.name == extends_name>
      <#assign import_name=module_name>
      <#break>
    </#if>
  </#list>
</#if>
<#assign import_namespace>
  <#lt>${import_name}<#if remoteClass.extends?? && remoteClass.extends.type.abstract>/abstracts</#if><#rt>
</#assign>
<#if remoteClass.abstract>abstracts/</#if>${remoteClass.name}.js
/* Autogenerated with Kurento Idl */

<#include "license.ftm" >

var inherits = require('inherits');
<#include "sugarSyntax1.ftm" >
<#if remoteClass.methods?has_content>

var checkType = require('checktype');
</#if>


<#if remoteClass.extends??>

  <#if import_name == module_name>
var ${extends_name} = require('./<#if remoteClass.abstract != remoteClass.extends.type.abstract>abstracts/</#if>${extends_name}');
  <#else>
var ${extends_name} = require('${import_namespace}').${extends_name};
  </#if>
<#elseif remoteClass.name=="MediaObject">

var ${extends_name} = require('events').${extends_name};
</#if>


/**
<#if remoteClass.constructor?? && remoteClass.constructor.doc??>
  <#list remoteClass.constructor.doc?split("\n") as line>
 * ${sphinxLinks(line, remoteClass_namepath)}
  </#list>
 *
</#if>
<#if remoteClass.doc??>
 * @classdesc
  <#list remoteClass.doc?split("\n") as line>
 *  ${sphinxLinks(line, remoteClass_namepath)}
  </#list>
 *
</#if>
<#if remoteClass.abstract>
 * @abstract
</#if>
<#if remoteClass.extends??>
 * @extends module:${import_namespace}.${extends_name}
<#elseif remoteClass.name=="MediaObject">
 * @extends external:${extends_name}
</#if>
 *
 * @constructor module:${remoteClass_namepath}
 *
 * @param {external:String} id
<#if remoteClass.events?? && remoteClass.events?has_content>
 *
  <#list remoteClass.events?sort_by("name") as event>
 * @fires {@link module:${module_name}#event:${event.name} ${event.name}}
  </#list>
</#if>
 */
function ${remoteClass.name}(id){<#if extends_name??>
  ${extends_name}.call(this, id);
</#if>
<#include "MediaObject_constructor.ftm" >};
<#if extends_name??>
inherits(${remoteClass.name}, ${extends_name});
</#if>
<#if remoteClass.properties?has_content>

  <#list remoteClass.properties?sort_by("name") as property>
    <#if property.name != "id">
      <#assign getPropertyName="get${property.name?cap_first}">

/**
      <#if property.doc??>
        <#list property.doc?split("\n") as line>
 * ${sphinxLinks(line, remoteClass_namepath)}
        </#list>
      </#if>
 *
 * @alias module:${remoteClass_namepath}#${getPropertyName}
 *
 * @param {module:${remoteClass_namepath}~${getPropertyName}Callback} [callback]
 *
 * @return {external:Promise}
 */
${remoteClass.name}.prototype.${getPropertyName} = function(callback){
  return this.invoke('${getPropertyName}', callback);
};
/**
 * @callback module:${remoteClass_namepath}~${getPropertyName}Callback
 * @param {external:Error} error
 * @param {${namepath(property.type.name)}} result
 */
    </#if>
  </#list>
</#if>
<#if remoteClass.methods?has_content>

  <#list remoteClass.methods?sort_by("name") as method>

    <#assign methodParams_name=[]>
    <#list method.params as param>
      <#assign methodParams_name=methodParams_name+[param.name]>
    </#list>
/**
    <#if method.doc??>
      <#list method.doc?split("\n") as line>
 * ${sphinxLinks(line, remoteClass_namepath)}
      </#list>
 *
    </#if>
 * @alias module:${remoteClass_namepath}.${method.name}
    <#list method.params as param>
 *
 * @param {${namepath(param.type.name)}}<#if param.type.isList()>[]</#if> <#if param.optional>[${param.name}]<#else>${param.name}</#if>
      <#if param.doc??>
        <#list param.doc?split("\n") as line>
 *  ${sphinxLinks(line, remoteClass_namepath)}
        </#list>
      </#if>
    </#list>
 *
 * @param {module:${remoteClass_namepath}~${method.name}Callback} [callback]
 *
 * @return {external:Promise}
 */
${remoteClass.name}.prototype.${method.name} = function(<@join sequence=(methodParams_name + ["callback"]) separator=", "/>){
    <#if method.params?has_content>
      <#list method.params as param>
        <#if param.optional>
  callback = arguments[arguments.length-1] instanceof Function
           ? Array.prototype.pop.call(arguments)
           : undefined;

//  eval(['<@join sequence=methodParams_name separator="', '"/>'][arguments.length]+'=undefined')
  if(callback)
    switch(arguments.length){
          <#list method.params as param>
            <#if param.optional>
      case ${param_index}: ${param.name} = undefined; break;
            </#if>
          </#list>
    }

          <#break>
        </#if>
      </#list>
      <#list method.params as param>
  checkType('${param.type.name}', '${param.name}', ${param.name}<#if param.type.isList() || !param.optional>, {<#if param.type.isList()>isList: true,</#if><#if !param.optional>required: true</#if>}</#if>);
      </#list>

  var params = {
      <#list methodParams_name as name>
    ${name}: ${name},
      </#list>
  };

    </#if>
  return this.invoke('${method.name}'<#if method.params?has_content>, params</#if>, callback);
};
/**
 * @callback module:${remoteClass_namepath}~${method.name}Callback
 * @param {external:Error} error
    <#if method.return??>
 * @param {${namepath(method.return.type.name)}} result
      <#list method.return.doc?split("\n") as line>
 *  ${sphinxLinks(line, remoteClass_namepath)}
      </#list>
    </#if>
 */
  </#list>
</#if>

<#include "sugarSyntax2.ftm" >

/**
 * @alias module:${remoteClass_namepath}.constructorParams
<#if remoteClass.constructor??>
  <#list remoteClass.constructor.params?sort_by("name") as param>
 *
 * @property {${namepath(param.type.name)}} <#if param.optional>[${param.name}]<#else>${param.name}</#if>
    <#if param.doc??>
      <#list param.doc?split("\n") as line>
 *  ${sphinxLinks(line, remoteClass_namepath)}
      </#list>
    </#if>
  </#list>
</#if>
 */
${remoteClass.name}.constructorParams = {<#list (remoteClass.constructor.params?sort_by("name"))![] as param>
  ${param.name}: {
    type: '${param.type.name}',
  <#if param.type.isList()>
    isList: true,
  </#if>
  <#if !param.optional>
    required: true
  </#if>
  },
</#list>};

/**
 * @alias module:${remoteClass_namepath}.events
<#if remoteClass.extends??>
 *
 * @extend module:${import_namespace}.${extends_name}.events
</#if>
 */
<#assign remoteClassEvents_name=[]>
<#list remoteClass.events?sort_by("name") as event>
  <#assign remoteClassEvents_name=remoteClassEvents_name+["'"+event.name+"'"]>
</#list>
${remoteClass.name}.events = [<@join sequence=remoteClassEvents_name separator=", "/>];
<#if remoteClass.extends??>
${remoteClass.name}.events.concat(${extends_name}.events);
</#if>


module.exports = ${remoteClass.name};


${remoteClass.name}.check = function(key, value)
{
  if(!(value instanceof ${remoteClass.name}))
    throw SyntaxError(key+' param should be a ${remoteClass.name}, not '+typeof value);
};
