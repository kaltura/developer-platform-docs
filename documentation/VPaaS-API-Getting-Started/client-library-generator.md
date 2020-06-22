---
layout: page
title: Adding a New Kaltura API Client Library Generator
weight: 106
---

The Kaltura API Client Library Generator is an automatic method of packaging the native API client libraries from the latest API code. The Kaltura Server provides a unique way of generating an always up-to-date native API Client Libraries by using an XML based reflection of Kaltura's internal API classes (API services, actions, objects, Enums...).

## The API Schema

The updated version of the API description can be retrieved [here](http://www.kaltura.com/api_v3/api_schema.php)

By parsing the schema.xml file,  it is possible to construct the complete structure of the objects in the system. A generic template to parse the schema file was created to ease the process of creating new parsers. The TemplateClientGenerator is a basic template for creating a custom client library generator, by providing the following:

A high-level parsing of class types: Enums, Objects and Services (implemented in the generate() function).
A template of parsing functions to be overridden or replaced by the actual parser implementation to create the client library of the target programming language.
The schema structure

**The schema is divided to three main sections:**

- **Enums** - Constants and Types defined and used by the system.
- **Classes** - Objects (Value Objects) defined and used by the system.
- **Services** - The Services and Actions defined and exposed by the system API to manipulate the Objects.

*Every node defines a respective part of the system (whether enum, class or service) and provides the following information:*

**Enums:** Define name and value of the constant properties of the enum class.

**Classes:** Define name, variable type (string, int, etc.), if the property is readOnly (read) or insertOnly (write) and description of the class and it's uses.

**Services:** Define a list of actions available, the parameters sent required by the action, the service and actions description and uses.
Creating a custom client library generator

## Supporting additional languages

If you wish to create a Kaltura API client library for a currently unsupported language, start by reviewing the existing generators [here](https://github.com/kaltura/clients-generator/tree/master/lib)

Please note that the `clients-generator` repo is a FOSS project (licensed under AGPLv3) and that we welcome code contributions.

### Helper functions

The [`ClientGeneratorFromXml`](https://github.com/kaltura/clients-generator/blob/master/lib/ClientGeneratorFromXml.php) class provides the following helper functions to ease development:

- `setParam` / `getParam` - An interface to add custom parameters during generation (this can be used to create configurable client libraries, e.g. the flash and flex client libraries are generated from the same generator class, by default it creates the flash library, however, when passing a parameter 'type' with value of 'flex_client' the generator will create a Flex library).
- `endsWith` - Test if a given string ends with another string.
- `beginsWith` - Test if a given string starts with another string.

### The PHP Reflection Generator

In addition to the method of using the schema XML, there is also a method of creating a Client Library Generator by extending the ClientGeneratorFromPhp class. The ClientGeneratorFromPhp class provides a reflection mechanism that doesn't require the step of creating or downloading the schema XML. However, this method requires that the full server will be deployed and configured. This method should be treated as deprecated and avoided.

