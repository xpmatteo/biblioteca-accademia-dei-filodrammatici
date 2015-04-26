require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../import_test_helper'

class ImportUnimarcHierarchyTest < Test::Unit::TestCase
  include ImportTestHelper

  def setup
    Document.delete_all
    Author.delete_all
    Responsibility.delete_all
  end

  # 461 punta _sempre_ a un genitore
  # 464 punta _sempre_ a parti analitiche che puntano indietro con 463

  # 463 in una monografia punta a figli, in una parte analitica punta al genitore

  # caso opere di Carlo Ravasio
  # parent: prima o dopo i figli, monografia con link a parti 463
  # children: monografia con link a genitore 461 (segnatura)
  def test_import_hierarchy_461_463_461
    import make_xml(["piece0", [[461, "set"]]], 
                    ["set",    [[463, "piece0"], [463, "piece1"]]],
                    ["piece1", [[461, "set"]]])
     
    assert_parent_and_children "set", ["piece0", "piece1"]
  end

  # caso luigi camoletti da novara
  # parent: m1 contiene link 462 e 463 ai figli (no segn)
  # children: m2 contiene link 461 al genitore e 463 a ulteriori figli (no segn)
  # children: 
  def test_import_chaotic_hierarchy
    import make_xml(["subset", [[461, "set"], [463, "piece-indirect"]]],
                    ["set",    [[462, "subset"], [463, "piece-direct"]]],
                    ["piece-indirect", [[462, "subset"]]],
                    ["piece-direct",   [[461, "set"]]]
                    )
    assert_parent_and_children "set",    ["subset", "piece-direct"]
    assert_parent_and_children "subset", ["piece-indirect"]
  end

  # caso Vaudeville
  # parent: monografia con link a parti analitiche 464 (segnatura)
  # children: di seguito, parti analitiche con link 463 al genitore (no segnatura)
  def test_import_analytic_pieces
    import make_xml(["piece",  [[464, "part0"], [464, "part1"]]],
                    ["part0",  [[463, "piece"]]],
                    ["part1",  [[463, "piece"]]])

    assert_parent_and_children "piece", ["part0", "part1"]
    
    assert_nil Document.find_by_id_sbn("piece").parent, "circular relation"
    assert_equal 0, Document.find_by_id_sbn("part0").children.count
    assert_equal 0, Document.find_by_id_sbn("part1").children.count
  end

  def test_it_should_work_with_iccu_codes
    import make_xml(['IT\ICCU\AQ1\0011111', [[463, 'IT\ICCU\AQ1\0022222']]],
                    ['IT\ICCU\AQ1\0022222', [[461, 'IT\ICCU\AQ1\0011111']]])
     
    assert_parent_and_children 'AQ10011111', ['AQ10022222']    
  end

private 
  def assert_parent_and_children(parent_id, children_ids)
    assert_not_nil parent = Document.find_by_id_sbn(parent_id), "parent #{parent_id} not found"
    assert_equal children_ids.sort, parent.children.map { |child| child.id_sbn }.sort
    assert_equal "composition", parent.hierarchy_type
    parent.children.each {|child| assert_equal "composition", child.hierarchy_type }
  end

  def make_xml(*recipes)
    cards = recipes.map {|recipe| make_card(recipe.first, recipe.last)}.join
    "<collection>#{cards}</collection>"
  end

  def make_card(id, links)
    links = links.map {|link| make_link(link.first, link.last)}.join
    <<-SCHEDA
      <record>
        <leader>03225nam0a2200517  I450 </leader>
        <controlfield tag="001">#{id}</controlfield>
        <datafield tag="200" ind1="1" ind2=" ">
          <subfield code="a">#{id}</subfield>
        </datafield>
        #{links}
      </record>
    SCHEDA
  end

  def make_link(tag, destination)
    <<-LINK
      <datafield tag='#{tag}' ind1=' ' ind2='1'>
        <subfield code='1'>001#{destination}</subfield>
        <subfield code='a'>Il viaggio del signor Perrichon</subfield>
      </datafield>
    LINK
  end
end
