
begin
$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')
require 'midilib/io/seqreader'
require 'midilib/io/seqwriter'

require 'midilib/sequence'
require 'midilib/consts'
include MIDI
# Create a new, empty sequence.
seq = Sequence.new()

# Read the contents of a MIDI file into the sequence.
File.open('1.mid', 'rb') { | file |
    seq.read(file) { | track, num_tracks, i |
        # Print something when each track is read.
        puts "read track #{i} of #{num_tracks}"
    }
}

# Iterate over every event in every track.
seq.each { | track |
    track.each { | event |
        # If the event is a note event (note on, note off, or poly
        # pressure) and it is on MIDI channel 5 (channels start at
        # 0, so we use 4), then transpose the event down one octave.
        if MIDI::NoteEvent === event && event.channel == 4
            event.note -= 12
        end
    }
}

# Write the sequence to a MIDI file.
File.open('my_output_file.mid', 'wb') { | file | seq.write(file) }



rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"