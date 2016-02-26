require 'irwi/comparators/base'

class Irwi::Comparators::DiffLcs < Irwi::Comparators::Base
  def initialize
    super

    require 'diff/lcs'
  end

  def build_changes(old_text, new_text)
    old_text ||= ''
    new_text ||= ''

    # Build symmetric diff sequence
    diffs = Diff::LCS.sdiff(old_text.mb_chars, new_text.mb_chars)

    # Transform diff changes to spans
    diffs.each_with_object [], &method(:append_change)
  end

  private

  def append_change(change, changes)
    case change.action
    when '=' then append_not_changed(changes, change.old_element)
    when '+' then append_added(changes, change.new_element)
    when '-' then append_removed(changes, change.old_element)
    when '!' then append_replaced(changes, change.old_element, change.new_element)
    end
  end

  def append_not_changed(changes, element)
    if !changes.empty? && changes.last.action == '=' # Append to last not changed span, if exists
      changes.last.value << element
    else
      changes << new_not_changed(element)
    end
  end

  def append_added(changes, new_element)
    last_action = changes.last && changes.last.action

    if last_action == '+' # Append to last addition, if exists
      changes.last.new_value << new_element
    elsif last_action == '!' # Append to last replace, if exists (it's necessary when replacing short string with a new long)
      changes.last.new_value << new_element
    else
      changes << new_changed('+', nil, new_element)
    end
  end

  def append_removed(changes, old_element)
    if !changes.empty? && changes.last.action == '-' # Append to last deletion, if exists
      changes.last.old_value << old_element
    else
      changes << new_changed('-', old_element, nil)
    end
  end

  def append_replaced(changes, old_element, new_element)
    if !changes.empty? && changes.last.action == '!' # Append to last replace, if exists
      changes.last.old_value << old_element
      changes.last.new_value << new_element
    else
      changes << new_changed('!', old_element, new_element)
    end
  end
end
