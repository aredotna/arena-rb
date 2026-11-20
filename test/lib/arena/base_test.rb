# frozen_string_literal: true

require_relative '../../test_helper'

describe Arena::Base do
  describe '.class_for' do
    it 'returns Arena classes' do
      assert_equal Arena::Text, Arena::Base.class_for('Text')
      assert_equal Arena::Channel, Arena::Base.class_for('Channel')
      assert_equal Arena::User, Arena::Base.class_for(:User)
    end

    it 'rejects classes outside of Arena' do
      %w[File Object Kernel].each do |name|
        assert_raises(Arena::Error) { Arena::Base.class_for(name) }
      end
    end

    it 'rejects Arena constants that are not Arena::Base classes' do
      %w[Client VERSION Configurable].each do |name|
        assert_raises(Arena::Error) { Arena::Base.class_for(name) }
      end
    end

    it 'rejects invalid names' do
      ['Arena::Text', '', nil, 'text', 'Text; exit'].each do |name|
        error = assert_raises(Arena::Error) { Arena::Base.class_for(name) }

        assert_equal "Unexpected class #{name.inspect}", error.message
      end
    end
  end
end

describe Arena::Channel do
  it 'instantiates contents' do
    channel = Arena::Channel.new('contents' => [{ 'class' => 'Text', 'id' => 1 }, { 'class' => 'Channel', 'id' => 2 }])

    assert_equal [Arena::Text, Arena::Channel], channel.contents.map(&:class)
  end
end

describe Arena::Story do
  it 'instantiates items' do
    story = Arena::Story.new('item_type' => 'Image', 'item' => { 'id' => 1 }, 'target_type' => nil, 'target' => nil)

    assert_instance_of Arena::Image, story.item
    assert_nil story.target
  end
end

describe Arena::SearchResults do
  it 'instantiates results' do
    results = Arena::SearchResults.new('users' => [{ 'id' => 1 }], 'channels' => [], 'blocks' => [{ 'id' => 2 }])

    assert_instance_of Arena::User, results.users.first
    assert_empty results.channels
    assert_instance_of Arena::Block, results.blocks.first
  end
end

describe String do
  it 'is not monkey patched' do
    refute_respond_to 'Arena', :constantize
  end
end
