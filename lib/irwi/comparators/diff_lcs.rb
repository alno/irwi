require 'irwi/comparators/base'

class Irwi::Comparators::DiffLcs < Irwi::Comparators::Base

  def initialize
    super

    require 'diff/lcs'
  end

  def build_changes( old_text, new_text )
    diffs = Diff::LCS.sdiff( (old_text || '').mb_chars, (new_text || '').mb_chars ) # Building symmetric diff sequence
    changes = [] # Array for our result changes

    diffs.each do |change|
      case change.action
        when '=' then
          if !changes.empty? && changes.last.action == '=' # Append to last not changed span, if exists
            changes.last.value << change.old_element
          else
            changes << new_not_changed( change.old_element )
          end

        when '+' then
          if !changes.empty? && changes.last.action == '+' # Append to last addition, if exists
            changes.last.new_value << change.new_element
          elsif !changes.empty? && changes.last.action == '!' # Append to last replace, if exists (it's necessary when replacing short string with a new long)
            changes.last.new_value << change.new_element
          else
            changes << new_changed( '+', nil, change.new_element )
          end

        when '-' then
          if !changes.empty? && changes.last.action == '-' # Append to last deletion, if exists
            changes.last.old_value << change.old_element
          else
            changes << new_changed( '-', change.old_element, nil )
          end

        when '!' then
          if !changes.empty? && changes.last.action == '!' # Append to last replace, if exists
            changes.last.old_value << change.old_element
            changes.last.new_value << change.new_element
          else
            changes << new_changed( '!', change.old_element, change.new_element )
          end

      end
    end

    changes
  end

end
