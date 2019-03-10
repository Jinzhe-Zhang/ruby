
begin

require 'midilib'
include MIDI
# Start with a sequence that has something worth saving.
seq = read_or_create_seq_we_care_not_how()

# Write the sequence to a MIDI file.
File.open('my_output_file.mid', 'wb') { | file | seq.write(file) }






rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"