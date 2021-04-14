function jira::sort_hash(Hash $input) {
  # Puppet hashes are "insertion order", so this works to sort by key
  Hash(sort(Array($input)))
}
