We've got internal DSLs everywhere in Ruby
==========================================

* Rake, Sinatra, ActiveRecord, RSpec ...
* More! Everywhere!

<!-- * Line between API / DSL fuzzy
     * Domains tend to be fairly programmer-oriented -->

Why bother with external DSLs then?
===================================

* Syntax

<!-- Sometimes you have no choice - "Language" has been defined by someone else - you just need to parse it, Structured text you've scraped from the web, pre-defined protocols or file formats -->

But... Parsing is hard! Lets go shopping.
=========================================

* Compiler / Interpreter literature can be daunting

<img src="includes/teletubbies.jpg" width="400"/>

<!-- * a lot of confusing names like LL and LR that sound like teletubbies
     * maths / theory heavy
     * usually use C or a language like Scheme 
     * focused on building production compilers or pushing language theory -->

It doesn't have to be hard: Treetop
===================================

* rubyish way of writing minilanguages
* A PEG - Parsing Expression Grammar
* as used by Cucumber:

<img src="includes/cucumber.jpg" width="400"/>

Builds a tree
=============

<img src="includes/rubygrammar.jpg" width="95%" />

How do you use it then?
=======================

* You write a *Grammar*. A grammar is just a list of *Rules*
* Then either run tt to create a ruby parser:
    <pre>
    tt my_grammar.treetop 
    # =&gt; outputs a my_grammar.rb file
    </pre>
* Or use the polyglot gem to compile the grammar at runtime

<!-- * pure parser just says yes or no. not very useful, so we build a tree
     * defines how to build a tree structure the rules explain which bits of the input
       string should be used -->

Simple example - defining the grammar
=====================================

CODEFILE: samples/greeting.treetop

Simple example - using it
=========================

CODEFILE: samples/greeting_use.rb

A more realistic example
========================

* working on making it easy to write XMPP bot that can respond to chat room messages
* Actions defined with a standard internal-DSL approach:

<pre>listen /some message regxp/ do |msg|
  # do something, maybe send a reply to the room
end
</pre>

* The problem is that a typical regular expression may look like:

      <pre>/^\s*whereis\s+(.+?)(?:\s+(?:on\s+)?(.+?))?\s*$/</pre>

Replace the regular expression with a mini-language
===================================================

* This looks better:

<pre>
whereis &lt;person&gt; [[on] &lt;day&gt;]
</pre>

* Some more examples of actions:

<pre>
monitor build &lt;build_key&gt;
slap &lt;someone&gt; [for &lt;something&gt;]
</pre>
      
* more interesting than the greeting example, because we have nested structures

Grammar
=======

CODEFILE: samples/simple_bot.treetop


Getting it to do something
==========================

* You can treat the generated tree as a data structure (as with Greeting)
* You can make the tree responsible for actions (Interpreter pattern)
* Each node has an interpret method which does the appropriate thing for that node.
* Need to pass a context around to collect values

Adding code to nodes
====================

* Inline:

<pre>    rule optional
      "[" expression "]" {

        def interpret(context)
          "(?:" + elements.interpret(context)  + ")?"
        end

      }
    end
</pre>

* External module:

<pre>    rule optional
      "[" expression "]" &lt;OptionalNode&gt;
    end
</pre>

Warning!
========

* You can't define any type of grammar with Treetop. 
* Left recursion is OUT!

<pre>
rule infinite_loop
  infinite_loop / "will never be chosen"
end
</pre>

* A good book for more theory is Programming Pragmatics

Other Options
=============

* Ragel - from brief overview more complicated than treetop. Used in Mongrel.
* "Real" parser-generators ANTLR, Bison/Flex, lots more but not many specifically targeting ruby output
* Hand-written parsers

Thanks
======

* twitter: @knaveofdiamonds
* blog: http://knaveofdiamonds.tumblr.com
* code: http://github.com/knaveofdiamonds