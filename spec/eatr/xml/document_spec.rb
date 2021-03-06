require "spec_helper"

describe Eatr::Xml::Document do
  let(:document) { './spec/fixtures/xml/book.xml' }
  let(:schema) { './spec/fixtures/schema/book.yaml' }

  it "applies a schema to an XML file" do
    books = Eatr::Xml::Document.new(schema).parse(document)
    expect(books.count).to eq(1)
    expect(books.first.author).to eq('greggroth')
    expect(books.first.pages).to eq(120)
    expect(books.first.published_at).to eq(DateTime.new(2016, 11, 12, 8))
    expect(books.first.rating).to eq(8.9)
    expect(books.first.for_sale).to eq(false)
    expect(books.first.age).to eq(12)
    expect(books.first.summary).to eq('In this lovely ')
  end

  it "applies a schema to an XML document" do
    books = Eatr::Xml::Document.new(schema).parse(File.read(document))
    expect(books.count).to eq(1)
  end

  describe "parsing one document to multiple objects" do
    let(:schema) { './spec/fixtures/schema/chapters.yaml' }

    it "returns a collection of objects" do
      chapters = Eatr::Xml::Document.new(schema).parse(document)
      expect(chapters.count).to eq(2)
      expect(chapters[0].title).to eq('Ch 1')
      expect(chapters[1].title).to eq('Ch 2')
    end
  end

  describe "parsing document with namespaces" do
    let(:document) { './spec/fixtures/xml/namespace_library.xml' }
    let(:schema) { './spec/fixtures/schema/namespace_library.yaml' }

    it "returns a collection of objects" do
      books = Eatr::Xml::Document.new(schema).parse(document)
      expect(books.count).to eq(2)
      expect(books[0].title).to eq('Handy Book 1')
      expect(books[0].author).to eq('GR')
      expect(books[1].title).to eq('Handy Book 2')
      expect(books[1].author).to eq('Bob')
    end
  end

  describe '"remove_namespaces" option' do
    let(:document) { './spec/fixtures/xml/namespace_library.xml' }
    let(:schema) { './spec/fixtures/schema/library.yaml' }

    it "allows navigating the document without namespaces" do
      books = Eatr::Xml::Document.new(schema).parse(document)
      expect(books.count).to eq(2)
      expect(books[0].book_title).to eq('Handy Book 1')
      expect(books[1].book_title).to eq('Handy Book 2')
    end
  end

  describe '"field.required" option' do
    let(:document) { './spec/fixtures/xml/book.xml' }
    let(:schema) { './spec/fixtures/schema/book_icbn.yaml' }

    it "raises an error if a field cannot be located" do
      expect { Eatr::Xml::Document.new(schema).parse(document) }.to raise_error(Eatr::Xml::NodeNotFound, "Unable to find 'icbn' using xpath '//icbn'")
    end
  end
end

