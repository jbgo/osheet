require "test/helper"
require "osheet/column"

module Osheet

  class ColumnTest < Test::Unit::TestCase
    context "Osheet::Column" do
      subject { Column.new }

      should_be_a_styled_element(Column)
      should_be_a_worksheet_element(Column)
      should_be_a_workbook_element(Column)

      should_have_instance_method :width
      should_have_instance_methods :autofit, :autofit?
      should_have_instance_methods :hidden, :hidden?
      should_have_instance_method :meta

      should "set it's defaults" do
        assert_equal nil, subject.send(:get_ivar, "width")
        assert_equal false, subject.send(:get_ivar, "autofit")
        assert !subject.autofit?
        assert_equal false, subject.send(:get_ivar, "hidden")
        assert !subject.hidden?

        assert_equal nil, subject.meta
      end

    end
  end

  class ColumnAttributesTest < Test::Unit::TestCase
    context "that has attributes" do
      subject do
        Column.new do
          style_class "more poo"
          width  100
          autofit true
          hidden true
          meta(
            {}
          )
        end
      end

      should "should set them correctly" do
        assert_equal 100, subject.send(:get_ivar, "width")
        assert_equal true, subject.send(:get_ivar, "autofit")
        assert subject.autofit?
        assert_equal true, subject.send(:get_ivar, "hidden")
        assert subject.hidden?
        assert_equal({}, subject.meta)
      end

      should "know it's attribute(s)" do
        [:style_class, :width, :autofit, :hidden].each do |a|
          assert subject.attributes.has_key?(a)
        end
        assert_equal 'more poo', subject.attributes[:style_class]
        assert_equal 100, subject.attributes[:width]
        assert_equal true, subject.attributes[:autofit]
        assert_equal true, subject.attributes[:hidden]
      end

    end
  end

  class ColumnDataTest < Test::Unit::TestCase
    context "A column" do
      subject { Column.new }

      should "set it's width" do
        subject.width(false)
        assert_equal false, subject.width
        subject.width(180)
        assert_equal 180, subject.width
        subject.width(nil)
        assert_equal 180, subject.width
      end

      should "cast autofit and hidden to bool" do
        col = Column.new { autofit :true; hidden 'false'}
        assert_kind_of ::TrueClass, col.send(:get_ivar, "autofit")
        assert_kind_of ::TrueClass, col.send(:get_ivar, "hidden")
      end

    end
  end

  class ColumnPartialTest < Test::Unit::TestCase
    context "A workbook that defines column partials" do
      subject do
        Workbook.new {
          partial(:column_stuff) {
            width 200
            meta(:label => 'awesome')
          }

          worksheet { column {
            add :column_stuff
          } }
        }
      end

      should "add it's partials to it's markup" do
        assert_equal 200, subject.worksheets.first.columns.first.width
        assert_equal({:label => 'awesome'}, subject.worksheets.first.columns.first.meta)
      end

    end
  end

  class ColumnBindingTest < Test::Unit::TestCase
    context "a column defined w/ a block" do
      should "access instance vars from that block's binding" do
        @test = 50
        @col = Column.new { width @test }

        assert !@col.send(:instance_variable_get, "@test").nil?
        assert_equal @test, @col.send(:instance_variable_get, "@test")
        assert_equal @test.object_id, @col.send(:instance_variable_get, "@test").object_id
        assert_equal @test, @col.attributes[:width]
        assert_equal @test.object_id, @col.attributes[:width].object_id
      end
    end
  end

end
