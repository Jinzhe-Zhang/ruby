
begin
	require 'midilib/io/seqreader'

# Create a new, empty sequence.
seq = MIDI::Sequence.new()

# Read the contents of a MIDI file into the sequence.
File.open('C:\Users\Public\Music\Sample Music\Rich21.mid', 'rb') { | file |
    seq.read(file) { | track, num_tracks, i |
        # Print something when each track is read.
        puts "read track #{i} of #{num_tracks}"
    }
}
rescue Exception => e
	puts e.message
end
system "pause"