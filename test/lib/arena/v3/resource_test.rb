# frozen_string_literal: true

require_relative '../../../test_helper'

describe Arena::V3::Resource do
  let(:resource) do
    Arena::V3::Resource.new(
      'id' => 1,
      'title' => 'Ideas',
      'owner' => { 'slug' => 'dblock' },
      'collaborators' => [{ 'name' => 'A' }, { 'name' => 'B' }],
      'tags' => %w[x y],
      'metadata' => nil
    )
  end

  it 'reads attributes as methods' do
    assert_equal 1, resource.id
    assert_equal 'Ideas', resource.title
    assert_nil resource.metadata
  end

  it 'reads attributes with []' do
    assert_equal 'Ideas', resource[:title]
    assert_equal 'Ideas', resource['title']
    assert_nil resource[:missing]
  end

  it 'wraps nested objects and arrays' do
    assert_kind_of Arena::V3::Resource, resource.owner
    assert_equal 'dblock', resource.owner.slug
    assert_equal %w[A B], resource.collaborators.map(&:name)
    assert_equal %w[x y], resource.tags
  end

  it 'responds only to present attributes' do
    assert_respond_to resource, :title
    assert_respond_to resource, :metadata
    refute_respond_to resource, :missing
    assert_raises(NoMethodError) { resource.missing }
  end

  it 'checks keys' do
    assert resource.key?(:metadata)
    refute resource.key?(:missing)
  end

  it 'returns the underlying hash' do
    assert_equal 'Ideas', resource.to_h['title']
  end

  it 'compares by attributes' do
    assert_equal Arena::V3::Resource.new('id' => 1), Arena::V3::Resource.new('id' => 1)
    refute_equal Arena::V3::Resource.new('id' => 1), Arena::V3::Resource.new('id' => 2)
  end

  it 'handles nil' do
    assert_empty Arena::V3::Resource.new(nil).to_h
  end
end

describe Arena::V3::Collection do
  it 'enumerates data and exposes page meta' do
    collection = Arena::V3::Collection.new(
      'data' => [{ 'id' => 1 }, { 'id' => 2 }],
      'meta' => { 'current_page' => 1, 'next_page' => 2, 'has_more_pages' => true }
    )

    assert_equal [1, 2], collection.map(&:id)
    assert_equal 2, collection.size
    refute_empty collection
    assert_equal 2, collection.meta.next_page
    assert_predicate collection, :more?
  end

  it 'exposes cursor meta' do
    collection = Arena::V3::Collection.new('data' => [], 'meta' => { 'next_cursor' => nil, 'has_more' => false })

    assert_empty collection
    refute_predicate collection, :more?
  end

  it 'handles a missing data' do
    assert_empty Arena::V3::Collection.new({})
  end
end
