# @summary Sort a hash
# @return Returns a sorted hash
# @api private
function jira::sort_hash(Hash $input) >> Hash {
  # Puppet hashes are "insertion order", so this works to sort by key
  Hash(sort(Array($input)))
}
