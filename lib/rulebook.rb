# This file is part of the Ruleby project (http://ruleby.org)
#
# This application is free software; you can redistribute it and/or
# modify it under the terms of the Ruby license defined in the
# LICENSE.txt file.
# 
# Copyright (c) 2007 Joe Kutner and Matt Smith. All rights reserved.
#
# * Authors: Matt Smith, Joe Kutner
#

require 'ruleby'
require 'rule_helper'
require 'dsl/magnum'

module Ruleby
  class Rulebook
    include Ruleby
    include Ruleby::RuleHelper
    def initialize(engine, &block)
      @engine = engine
      yield self if block_given?
    end
  
    attr_reader :engine
    
    def assert(fact)
      @engine.assert fact
    end
    def retract(fact)
      @engine.retract fact
    end
    def modify(fact)
      @engine.modify fact
    end
    def rule(*args, &block)      
      raise 'Must provide arguments to rule' if args.empty?      
      r = Ruleby::Magnum::RulebookHelper.new @engine
      r.rule *args, &block
    end
  end
  
  class GeneratedTag  
    # this counter is incremented for each UniqueTag created, and is
    # appended to the end of the unique_seed in order to create a 
    # string that is unique for each instance of this class.
    @@tag_counter = 0

    # every generated tag will be prefixed with this string.  This isn't full-proof.
    @@unique_seed = 'unique_seed'

    def initialize()
      @@tag_counter += 1
      @tag = @@unique_seed + @@tag_counter.to_s
    end

    attr_reader:tag_counter
    attr_reader:unique_seed
    attr_reader:tag

    def ==(ut)
      return ut && ut.kind_of?(GeneratedTag) && @tag == ut.tag
    end

    def to_s
      return @tag.to_s
    end
  end
end