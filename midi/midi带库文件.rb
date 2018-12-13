
module MIDI

  # The abstract superclass of all MIDI events.
  class Event

    # Modifying delta_time does not affect time_from_start. You need to call
    # the event's track's +recalc_time+ method.
    attr_accessor :delta_time
    # The start time of this event from the beginning of the track. This value
    # is held here but is maintained by the track.
    attr_accessor :time_from_start
    # The MIDI status byte. Never includes the channel, which is held
    # separately by MIDI::ChannelEvent.
    attr_reader :status

    # Determines if to_s outputs hex note numbers (false, the default) or
    # decimal note names (true).
    attr_accessor :print_note_names

    # Determines if to_s outputs numbers as hex (false, the default) or
    # decimal # (true). Delta times are always printed as decimal.
    attr_accessor :print_decimal_numbers

    # Determines if to_s outputs MIDI channel numbers from 1-16 instead
    # of the default 0-15.
    attr_accessor :print_channel_numbers_from_one

    def initialize(status = 0, delta_time = 0)
      @status = status
      @delta_time = delta_time
      @time_from_start = 0	# maintained by tracks
    end
    protected :initialize

    # Returns the raw bytes that are written to a MIDI file or output to a
    # MIDI stream. In MIDI::EVENT this raises a "subclass responsibility"
    # exception.
    def data_as_bytes
      raise "subclass responsibility"
    end

    # Quantize this event's time_from_start by moving it to the nearest
    # multiple of +boundary+. See MIDI::Track#quantize. *Note*: does not
    # modify the event's delta_time, though MIDI::Track#quantize calls
    # recalc_delta_from_times after it asks each event to quantize itself.
    def quantize_to(boundary)
      diff = @time_from_start % boundary
      @time_from_start -= diff
      if diff >= boundary / 2
        @time_from_start += boundary
      end
    end

    # For sorting. Uses @time_from_start, which is maintained by this event's
    # track. I'm not sure this is necessary, since each track has to
    # maintain its events' time-from-start values anyway.
    def <=>(an_event)
      return @time_from_start <=> an_event.time_from_start
    end

    # Returns +val+ as a decimal or hex string, depending upon the value of
    # @print_decimal_numbers.
    def number_to_s(val)
      return @print_decimal_numbers ? val.to_s : ('%02x' % val)
    end

    # Returns +val+ as a decimal or hex string, depending upon the value of
    # @print_decimal_numbers.
    def channel_to_s(val)
      val += 1 if @print_channel_numbers_from_one
      return number_to_s(val)
    end

    def to_s
      "#{@delta_time}: "
    end
  end

  # The abstract superclass of all channel events (events that have a MIDI
  # channel, like notes and program changes).
  class ChannelEvent < Event
    # MIDI channel, 0-15.
    attr_accessor :channel

    def initialize(status, channel, delta_time)
      super(status, delta_time)
      @channel = channel
    end
    protected :initialize

    def to_s
      return super << "ch #{channel_to_s(@channel)} "
    end

  end

  # The abstract superclass of all note on, and note off, and polyphonic
  # pressure events.
  class NoteEvent < ChannelEvent
    attr_accessor :note, :velocity
    def initialize(status, channel, note, velocity, delta_time)
      super(status, channel, delta_time)
      @note = note
      @velocity = velocity
    end
    protected :initialize

    PITCHES = %w(C C# D D# E F F# G G# A A# B)

    # Returns note name as a pitch/octave string like "C4" or "F#6".
    def pch_oct(val=@note)
      pch = val % 12
      oct = (val / 12) - 1
      "#{PITCHES[pch]}#{oct}"
    end

    # If @print_note_names is true, returns pch_oct(val) else returns value
    # as a number using number_to_s.
    def note_to_s
      return @print_note_names ? pch_oct(@note) : number_to_s(@note)
    end

    def data_as_bytes
      data = []
      data << (@status + @channel)
      data << @note
      data << @velocity
    end
  end

  class NoteOn < NoteEvent
    attr_accessor :off
    def initialize(channel = 0, note = 64, velocity = 64, delta_time = 0)
      super(NOTE_ON, channel, note, velocity, delta_time)
    end

    def to_s
      return super <<
        "on #{note_to_s} #{number_to_s(@velocity)}"
    end
  end

  # Old class name for compatability
  NoteOnEvent = NoteOn

  class NoteOff < NoteEvent
    attr_accessor :on
    def initialize(channel = 0, note = 64, velocity = 64, delta_time = 0)
      super(NOTE_OFF, channel, note, velocity, delta_time)
    end

    def to_s
      return super <<
        "off #{note_to_s} #{number_to_s(@velocity)}"
    end
  end

  # Old class name for compatability
  NoteOffEvent = NoteOff

  class PolyPressure < NoteEvent
    def initialize(channel = 0, note = 64, value = 0, delta_time = 0)
      super(POLY_PRESSURE, channel, note, value, delta_time)
    end

    def pressure
      return @velocity
    end
    def pressure=(val)
      @velocity = val
    end
    def to_s
      return super <<
        "poly press #{channel_to_s(@channel)} #{note_to_s} #{number_to_s(@velocity)}"
    end
  end

  class Controller < ChannelEvent
    attr_accessor :controller, :value

    def initialize(channel = 0, controller = 0, value = 0, delta_time = 0)
      super(CONTROLLER, channel, delta_time)
      @controller = controller
      @value = value
    end

    def data_as_bytes
      data = []
      data << (@status + @channel)
      data << @controller
      data << @value
    end

    def to_s
      return super << "cntl #{number_to_s(@controller)} #{number_to_s(@value)}"
    end
  end

  class ProgramChange < ChannelEvent
    attr_accessor :program

    def initialize(channel = 0, program = 0, delta_time = 0)
      super(PROGRAM_CHANGE, channel, delta_time)
      @program = program
    end

    def data_as_bytes
      data = []
      data << (@status + @channel)
      data << @program
    end

    def to_s
      return super << "prog #{number_to_s(@program)}"
    end
  end

  class ChannelPressure < ChannelEvent
    attr_accessor :pressure

    def initialize(channel = 0, pressure = 0, delta_time = 0)
      super(CHANNEL_PRESSURE, channel, delta_time)
      @pressure = pressure
    end

    def data_as_bytes
      data = []
      data << (@status + @channel)
      data << @pressure
    end

    def to_s
      return super << "chan press #{number_to_s(@pressure)}"
    end
  end

  class PitchBend < ChannelEvent
    attr_accessor :value

    def initialize(channel = 0, value = 0, delta_time = 0)
      super(PITCH_BEND, channel, delta_time)
      @value = value
    end

    def data_as_bytes
      data = []
      data << (@status + @channel)
      data << (@value & 0x7f) # lsb
      data << ((@value >> 7) & 0x7f) # msb
    end

    def to_s
      return super << "pb #{number_to_s(@value)}"
    end
  end

  class SystemCommon < Event
    def initialize(status, delta_time)
      super(status, delta_time)
    end
  end

  class SystemExclusive < SystemCommon
    attr_accessor :data

    def initialize(data, delta_time = 0)
      super(SYSEX, delta_time)
      @data = data
    end

    def data_as_bytes
      data = []
      data << @status
      data << Utils.as_var_len(@data.length)
      data << @data
      data << EOX
      data.flatten
    end

    def to_s
      return super << "sys ex"
    end
  end

  class SongPointer < SystemCommon
    attr_accessor :pointer

    def initialize(pointer = 0, delta_time = 0)
      super(SONG_POINTER, delta_time)
      @pointer = pointer
    end

    def data_as_bytes
      data = []
      data << @status
      data << ((@pointer >> 8) & 0xff)
      data << (@pointer & 0xff)
    end

    def to_s
      return super << "song ptr #{number_to_s(@pointer)}"
    end
  end

  class SongSelect < SystemCommon
    attr_accessor :song

    def initialize(song = 0, delta_time = 0)
      super(SONG_SELECT, delta_time)
      @song = song
    end

    def data_as_bytes
      data = []
      data << @status
      data << @song
    end

    def to_s
      return super << "song sel #{number_to_s(@song)}"
    end
  end

  class TuneRequest < SystemCommon
    def initialize(delta_time = 0)
      super(TUNE_REQUEST, delta_time)
    end

    def data_as_bytes
      data = []
      data << @status
    end

    def to_s
      return super << "tune req"
    end
  end

  class Realtime < Event
    def initialize(status, delta_time)
      super(status, delta_time)
    end

    def data_as_bytes
      data = []
      data << @status
    end

    def to_s
      return super << "realtime #{number_to_s(@status)}"
    end
  end

  class Clock < Realtime
    def initialize(delta_time = 0)
      super(CLOCK, delta_time)
    end

    def to_s
      return super << "clock"
    end
  end

  class Start < Realtime
    def initialize(delta_time = 0)
      super(START, delta_time)
    end
    def to_s
      return super << "start"
    end
  end

  class Continue < Realtime
    def initialize(delta_time = 0)
      super(CONTINUE, delta_time)
    end
    def to_s
      return super << "continue"
    end
  end

  class Stop < Realtime
    def initialize(delta_time = 0)
      super(STOP, delta_time)
    end
    def to_s
      return super << "stop"
    end
  end

  class ActiveSense < Realtime
    def initialize(delta_time = 0)
      super(ACTIVE_SENSE, delta_time)
    end
    def to_s
      return super << "act sens"
    end
  end

  class SystemReset < Realtime
    def initialize(delta_time = 0)
      super(SYSTEM_RESET, delta_time)
    end
    def to_s
      return super << "sys reset"
    end
  end

  class MetaEvent < Event
    attr_reader :meta_type
    attr_reader :data

    def self.bytes_as_str(bytes)
      bytes ? bytes.collect { |byte| byte.chr }.join : nil
    end

    if RUBY_VERSION >= '1.9'
      def self.str_as_bytes(str)
        str.split(//).collect { |chr| chr.ord }
      end
    else
      def self.str_as_bytes(str)
        str.split(//).collect { |chr| chr[0] }
      end
    end

    def initialize(meta_type, data = nil, delta_time = 0)
      super(META_EVENT, delta_time)
      @meta_type = meta_type
      self.data=(data)
    end

    def data_as_bytes
      data = []
      data << @status
      data << @meta_type
      data << (@data ? Utils.as_var_len(@data.length) : 0)
      data << @data if @data
      data.flatten
    end

    def data_as_str
      MetaEvent.bytes_as_str(@data)
    end

    # Stores bytes. If data is a string, splits it into an array of bytes.
    def data=(data)
      case data
      when String
        @data = MetaEvent.str_as_bytes(data)
      else
        @data = data
      end
    end

    def to_s
      str = super()
      str << "meta #{number_to_s(@meta_type)} "
      # I know, I know...this isn't OO.
      case @meta_type
      when META_SEQ_NUM
        str << "sequence number"
      when META_TEXT
        str << "text: #{data_as_str}"
      when META_COPYRIGHT
        str << "copyright: #{data_as_str}"
      when META_SEQ_NAME
        str << "sequence or track name: #{data_as_str}"
      when META_INSTRUMENT
        str << "instrument name: #{data_as_str}"
      when META_LYRIC
        str << "lyric: #{data_as_str}"
      when META_MARKER
        str << "marker: #{data_as_str}"
      when META_CUE
        str << "cue point: #{@data}"
      when META_TRACK_END
        str << "track end"
      when META_SMPTE
        str << "smpte"
      when META_TIME_SIG
        str << "time signature"
      when META_KEY_SIG
        str << "key signature"
      when META_SEQ_SPECIF
        str << "sequence specific"
      else
        # Some other possible @meta_type values are handled by subclasses.
        str << "(other)"
      end
      return str
    end
  end

  class Marker < MetaEvent
    def initialize(msg, delta_time = 0)
      super(META_MARKER, msg, delta_time)
    end
  end

  class Tempo < MetaEvent

    MICROSECS_PER_MINUTE = 1_000_000 * 60

    # Translates beats per minute to microseconds per quarter note (beat).
    def Tempo.bpm_to_mpq(bpm)
      return MICROSECS_PER_MINUTE / bpm
    end

    # Translates microseconds per quarter note (beat) to beats per minute.
    def Tempo.mpq_to_bpm(mpq)
      return MICROSECS_PER_MINUTE.to_f / mpq.to_f
    end

    def initialize(msecs_per_qnote, delta_time = 0)
      super(META_SET_TEMPO, msecs_per_qnote, delta_time)
    end

    def tempo
      return @data
    end

    def tempo=(val)
      @data = val
    end

    def data_as_bytes
      data = []
      data << @status
      data << @meta_type
      data << 3
      data << ((@data >> 16) & 0xff)
      data << ((@data >> 8) & 0xff)
      data << (@data & 0xff)
    end

    def to_s
      "tempo #{@data} msecs per qnote (#{Tempo.mpq_to_bpm(@data)} bpm)"
    end
  end

  # Container for time signature events
  class TimeSig < MetaEvent

    # Constructor
    def initialize(numer, denom, clocks, qnotes, delta_time = 0)
      super(META_TIME_SIG, [numer, denom, clocks, qnotes], delta_time)
    end

    # Returns the complete event as stored in the sequence
    def data_as_bytes
      data = []
      data << @status
      data << @meta_type
      data << 4
      data << @data[0]
      data << @data[1]
      data << @data[2]
      data << @data[3]
    end

    # Calculates the duration (in ticks) for a full measure
    def measure_duration(ppqn)
      (4 * ppqn * @data[0]) / (2**@data[1])
    end

    # Returns the numerator (the top digit) for the time signature
    def numerator
      @data[0]
    end

    # Returns the denominator of the time signature. Use it as a power of 2
    # to get the displayed (lower-part) digit of the time signature.
    def denominator
      @data[1]
    end

    # Returns the metronome tick duration for the time signature. On
    # each quarter note, there's 24 ticks.
    def metronome_ticks
      @data[2]
    end

    # Returns the time signature for the event as a string.
    # Example: "time sig 3/4"
    def to_s
      "time sig #{@data[0]}/#{2**@data[1]}"
    end
  end

  # Container for key signature events
  class KeySig < MetaEvent

    # Constructor
    def initialize(sharpflat, is_minor, delta_time = 0)
      super(META_KEY_SIG, [sharpflat, is_minor], delta_time)
    end

    # Returns the complete event as stored in the sequence
    def data_as_bytes
      data = []
      data << @status
      data << @meta_type
      data << 2
      data << @data[0]
      data << (@data[1] ? 1 : 0)
    end

    # Returns true if it's a minor key, false if major key
    def minor_key?
      @data[1]
    end

    # Returns true if it's a major key, false if minor key
    def major_key?
      !@data[1]
    end

    # Returns the number of sharps/flats in the key sig. Negative for flats.
    def sharpflat
      @data[0] > 7 ? @data[0] - 256 : @data[0]
    end

    # Returns the key signature as a text string.
    # Example: "key sig A flat major"
    def to_s
      majorkeys = ['C flat', 'G flat', 'D flat', 'A flat', 'E flat', 'B flat', 'F',
        'C', 'G', 'D', 'A', 'E', 'B', 'F#', 'C#']
      minorkeys = ['a flat', 'e flat', 'b flat', 'f', 'c', 'g', 'd',
        'a', 'e', 'b', 'f#', 'c#', 'g#', 'd#', 'a#']
      minor_key? ? "key sig #{minorkeys[sharpflat + 7]} minor" :
        "key sig #{majorkeys[sharpflat + 7]} major"
    end
  end

end

module MIDI

  # A MIDI::Sequence contains MIDI::Track objects.
  class Sequence

    include Enumerable

    UNNAMED = 'Unnamed Sequence'
    DEFAULT_TEMPO = 120

    NOTE_TO_LENGTH = {
      'whole' => 4.0,
      'half' => 2.0,
      'quarter' => 1.0,
      'eighth' => 0.5,
      '8th' => 0.5,
      'sixteenth' => 0.25,
      '16th' => 0.25,
      'thirty second' => 0.125,
      'thirtysecond' => 0.125,
      '32nd' => 0.125,
      'sixty fourth' => 0.0625,
      'sixtyfourth' => 0.0625,
      '64th' => 0.0625
    }

    # Array with all tracks for the sequence
    attr_accessor :tracks
    # Pulses (i.e. clocks) Per Quarter Note resolution for the sequence
    attr_accessor :ppqn
    # The MIDI file format (0, 1, or 2)
    attr_accessor :format
    attr_accessor :numer, :denom, :clocks, :qnotes
    # The class to use for reading MIDI from a stream. The default is
    # MIDI::IO::SeqReader. You can change this at any time.
    attr_accessor :reader_class
    # The class to use for writeing MIDI from a stream. The default is
    # MIDI::IO::SeqWriter. You can change this at any time.
    attr_accessor :writer_class

    def initialize
      @tracks = Array.new()
      @ppqn = 480

      # Time signature
      @numer = 4		# Numer + denom = 4/4 time default
      @denom = 2
      @clocks = 24    # Bug fix  Nov 11, 2007 - this is not the same as ppqn!
      @qnotes = 8

      @reader_class = IO::SeqReader
      @writer_class = IO::SeqWriter
    end

    # Sets the time signature.
    def time_signature(numer, denom, clocks, qnotes)
      @numer = numer
      @denom = denom
      @clocks = clocks
      @qnotes = qnotes
    end

    # Returns the song tempo in beats per minute.
    def beats_per_minute
      return DEFAULT_TEMPO if @tracks.nil? || @tracks.empty?
      event = @tracks.first.events.detect { |e| e.kind_of?(MIDI::Tempo) }
      return event ? (Tempo.mpq_to_bpm(event.tempo)) : DEFAULT_TEMPO
    end
    alias_method :bpm, :beats_per_minute
    alias_method :tempo, :beats_per_minute

    # Pulses (also called ticks) are the units of delta times and event
    # time_from_start values. This method converts a number of pulses to a
    # float value that is a time in seconds.
    def pulses_to_seconds(pulses)
      (pulses.to_f / @ppqn.to_f / beats_per_minute()) * 60.0
    end

    # Given a note length name like "whole", "dotted quarter", or "8th
    # triplet", return the length of that note in quarter notes as a delta
    # time.
    def note_to_delta(name)
      return length_to_delta(note_to_length(name))
    end

    # Given a note length name like "whole", "dotted quarter", or "8th
    # triplet", return the length of that note in quarter notes as a
    # floating-point number, suitable for use as an argument to
    # length_to_delta.
    #
    # Legal names are any value in NOTE_TO_LENGTH, optionally prefixed by
    # "dotted_" and/or suffixed by "_triplet". So, for example,
    # "dotted_quarter_triplet" returns the length of a dotted quarter-note
    # triplet and "32nd" returns 1/32.
    def note_to_length(name)
      name.strip!
      name =~ /^(dotted)?(.*?)(triplet)?$/
      dotted, note_name, triplet = $1, $2, $3
      note_name.strip!
      mult = 1.0
      mult = 1.5 if dotted
      mult /= 3.0 if triplet
      len = NOTE_TO_LENGTH[note_name]
      raise "Sequence.note_to_length: \"#{note_name}\" not understood in \"#{name}\"" unless len
      return len * mult
    end

    # Translates +length+ (a multiple of a quarter note) into a delta time.
    # For example, 1 is a quarter note, 1.0/32.0 is a 32nd note, 1.5 is a
    # dotted quarter, etc. Be aware when using division; 1/32 is zero due to
    # integer mathematics and rounding. Use floating-point numbers like 1.0
    # and 32.0. This method always returns an integer.
    #
    # See also note_to_delta and note_to_length.
    def length_to_delta(length)
      return (@ppqn * length).to_i
    end

    # Returns the name of the first track (track zero). If there are no
    # tracks, returns UNNAMED.
    def name
      return UNNAMED if @tracks.empty?
      return @tracks.first.name()
    end

    # Hands the name to the first track. Does nothing if there are no tracks.
    def name=(name)
      return if @tracks.empty?
      @tracks.first.name = name
    end

    # Reads a MIDI stream.
    def read(io, proc = nil)	# :yields: track, num_tracks, index
      reader = @reader_class.new(self, block_given?() ? Proc.new() : proc)
      reader.read_from(io)
    end

    # Writes to a MIDI stream.
    def write(io, proc = nil)	# :yields: track, num_tracks, index
      writer = @writer_class.new(self, block_given?() ? Proc.new() : proc)
      writer.write_to(io)
    end

    # Iterates over the tracks.
    def each			# :yields: track
      @tracks.each { |track| yield track }
    end

    # Returns a Measures object, which is an array container for all measures
    # in the sequence
    def get_measures
      # Collect time sig events and scan for last event time
      time_sigs = []
      max_pos = 0
      @tracks.each  do |t|
        t.each do |e|
          time_sigs << e if e.kind_of?(MIDI::TimeSig)
          max_pos = e.time_from_start if e.time_from_start > max_pos
        end
      end
      time_sigs.sort { |x,y| x.time_from_start <=> y.time_from_start }

      # Add a "fake" time sig event at the very last position of the sequence,
      # just to make sure the whole sequence is calculated.
      t = MIDI::TimeSig.new(4, 2, 24, 8, 0)
      t.time_from_start = max_pos
      time_sigs << t

      # Default to 4/4
      measure_length = @ppqn * 4
      oldnumer, olddenom, oldbeats = 4, 2, 24

      measures = MIDI::Measures.new(max_pos, @ppqn)
      curr_pos = 0
      curr_meas_no = 1
      time_sigs.each do |te|
        meas_count = (te.time_from_start - curr_pos) / measure_length
        meas_count += 1 if (te.time_from_start - curr_pos) % measure_length > 0
        1.upto(meas_count) do |i|
          measures << MIDI::Measure.new(curr_meas_no, curr_pos, measure_length,
                                        oldnumer, olddenom, oldbeats)
          curr_meas_no += 1
          curr_pos += measure_length
        end
        oldnumer, olddenom, oldbeats = te.numerator, te.denominator, te.metronome_ticks
        measure_length = te.measure_duration(@ppqn)
      end
      measures
    end

  end
end


module MIDI

  # This is taken from
  # http://github.com/adamjmurray/cosy/blob/master/lib/cosy/helper/midi_file_renderer_helper.rb
  # with permission from Adam Murray, who originally suggested this fix.
  # See http://wiki.github.com/adamjmurray/cosy/midilib-notes for details.
  # First we need to add some API infrastructure:
  class MIDI::Array < ::Array
    # This code borrowed from 'Moser' http://codesnippets.joyent.com/posts/show/1699

    # A stable sorting algorithm that maintains the relative order of equal elements
    def mergesort(&cmp)
      if cmp == nil
        cmp = lambda { |a, b| a <=> b }
      end
      if size <= 1
        self.dup
      else
        halves = split.map { |half| half.mergesort(&cmp) }
        merge(*halves, &cmp)
      end
    end

    protected
    def split
      n = (length / 2).floor - 1
      [self[0..n], self[n+1..-1]]
    end

    def merge(first, second, &predicate)
      result = []
      until first.empty? || second.empty?
        if predicate.call(first.first, second.first) <= 0
          result << first.shift
        else
          result << second.shift
        end
      end
      result.concat(first).concat(second)
    end
  end

  # A Track is a list of events.
  #
  # When you modify the +events+ array, make sure to call recalc_times so
  # each Event gets its +time_from_start+ recalculated.
  #
  # A Track also holds a bitmask that specifies the channels used by the track.
  # This bitmask is set when the track is read from the MIDI file by an
  # IO::SeqReader but is _not_ kept up to date by any other methods.

  class Track

    include Enumerable

    UNNAMED = 'Unnamed'

    attr_accessor :events, :channels_used
    attr_reader :sequence

    def initialize(sequence)
      @sequence = sequence
      @events = Array.new()

      # Bitmask of all channels used. Set when track is read in from
      # a MIDI file.
      @channels_used = 0
    end

    # Return track name. If there is no name, return UNNAMED.
    def name
      event = @events.detect { |e| e.kind_of?(MetaEvent) && e.meta_type == META_SEQ_NAME }
      event ? event.data_as_str : UNNAMED
    end

    # Set track name. Replaces or creates a name meta-event.
    def name=(name)
      event = @events.detect { |e| e.kind_of?(MetaEvent) && e.meta_type == META_SEQ_NAME }
      if event
        event.data = name
      else
        event = MetaEvent.new(META_SEQ_NAME, name, 0)
        @events[0, 0] = event
      end
    end

    def instrument
      MetaEvent.bytes_as_str(@instrument)
    end

    def instrument=(str_or_bytes)
      @instrument = case str_or_bytes
                    when String
                      MetaEvent.str_as_bytes(str_or_bytes)
                    else
                      str_or_bytes
                    end
    end

    # Merges an array of events into our event list. After merging, the
    # events' time_from_start values are correct so you don't need to worry
    # about calling recalc_times.
    def merge(event_list)
      @events = merge_event_lists(@events, event_list)
    end

    # Merges two event arrays together. Does not modify this track.
    def merge_event_lists(list1, list2)
      recalc_times(0, list1)
      recalc_times(0, list2)
      list = list1 + list2
      recalc_delta_from_times(0, list)
      return list
    end

    # Quantize every event. length_or_note is either a length (1 = quarter,
    # 0.25 = sixteenth, 4 = whole note) or a note name ("sixteenth", "32nd",
    # "8th triplet", "dotted quarter").
    #
    # Since each event's time_from_start is modified, we call
    # recalc_delta_from_times after each event quantizes itself.
    def quantize(length_or_note)
      delta = case length_or_note
              when String
                @sequence.note_to_delta(length_or_note)
              else
                @sequence.length_to_delta(length_or_note.to_i)
              end
      @events.each { |event| event.quantize_to(delta) }
      recalc_delta_from_times
    end

    # Recalculate start times for all events in +list+ from starting_at to
    # end.
    def recalc_times(starting_at=0, list=@events)
      t = (starting_at == 0) ? 0 : list[starting_at - 1].time_from_start
      list[starting_at .. -1].each do |e|
        t += e.delta_time
        e.time_from_start = t
      end
    end

    # The opposite of recalc_times: recalculates delta_time for each event
    # from each event's time_from_start. This is useful, for example, when
    # merging two event lists. As a side-effect, elements from starting_at
    # are sorted by time_from_start.
    def recalc_delta_from_times(starting_at=0, list=@events)
      prev_time_from_start = 0
      # We need to sort the sublist. sublist.sort! does not do what we want.
      # We call mergesort instead of Array.sort because sort is not stable
      # (it can mix up the order of events that have the same start time).
      # See http://wiki.github.com/adamjmurray/cosy/midilib-notes for details.
      list[starting_at .. -1] = MIDI::Array.new(list[starting_at .. -1]).mergesort do |e1, e2|
        e1.time_from_start <=> e2.time_from_start
      end
      list[starting_at .. -1].each do |e|
        e.delta_time = e.time_from_start - prev_time_from_start
        prev_time_from_start = e.time_from_start
      end
    end

    # Iterate over events.
    def each			# :yields: event
      @events.each { |event| yield event }
    end

    # Sort events by their time_from_start. After sorting,
    # recalc_delta_from_times is called to make sure that the delta times
    # reflect the possibly new event order.
    #
    # Note: this method is redundant, since recalc_delta_from_times sorts
    # the events first. This method may go away in a future release, or at
    # least be aliased to recalc_delta_from_times.
    alias_method :sort, :recalc_delta_from_times
  end

end

module MIDI

  # Utility methods.
  class Utils

    # MIDI note names. NOTE_NAMES[0] is 'C', NOTE_NAMES[1] is 'C#', etc.
    NOTE_NAMES = [
      'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
    ]

    # Given a MIDI note number, return the name and octave as a string.
    def Utils.note_to_s(num)
      note = num % 12
      octave = num / 12
      return "#{NOTE_NAMES[note]}#{octave - 1}"
    end

    # Given an integer, returns it as a variable length array of bytes (the
    # format used by MIDI files).
    #
    # The converse operation--converting a var len into a number--requires
    # input from a stream of bytes. Therefore we don't supply it here. That is
    # a part of the MIDIFile class.
    def Utils.as_var_len(val)
      buffer = []
      buffer << (val & 0x7f)
      val = (val >> 7)
      while val > 0
        buffer << (0x80 + (val & 0x7f))
        val = (val >> 7)
      end
      return buffer.reverse!
    end

  end
end


module MIDI

  # The Measure class contains information about a measure from the sequence.
  # The measure data is based on the time signature information from the sequence
  # and is not stored in the sequence itself
  class Measure
    # The numerator (top digit) for the measure's time signature
    attr_reader :numerator
    # The denominator for the measure's time signature
    attr_reader :denominator
    # Start clock tick for the measure
    attr_reader :start
    # End clock tick for the measure (inclusive)
    attr_reader :end
    # The measure number (1-based)
    attr_reader :measure_number
    # The metronome tick for the measure
    attr_reader :metronome_ticks

    # Constructor
    def initialize(meas_no, start_time, duration, numer, denom, met_ticks)
      @measure_number = meas_no
      @start = start_time
      @end = start_time + duration - 1
      @numerator = numer
      @denominator = denom
      @metronome_ticks = met_ticks
    end

    # Returns a detailed string with information about the measure
    def to_s
      t = "#{@numerator}/#{2**@denominator}"
      m = @metronome_ticks.to_f / 24
      "measure #{@measure_number}  #{@start}-#{@end}  #{t}   #{m} qs metronome"
    end

    # Returns +true+ if the event is in the measure
    def contains_event?(e)
      (e.time_from_start >= @start) && (e.time_from_start <= @end)
    end
  end

  # A specialized container for MIDI::Measure objects, which can be use to map
  # event times to measure numbers. Please note that this object has to be remade
  # when events are deleted/added in the sequence.
  class Measures < Array
    # The highest event time in the sequence (at the time when the
    # object was created)
    attr_reader :max_time

    # The ppqd from the sequence
    attr_reader :ppqd

    # Constructor
    def initialize(max_time, ppqd)
      super(0)
      @max_time = max_time
      @ppqd = ppqd
    end

    # Returns the MIDI::Measure object where the event is located.
    # Returns +nil+ if the event isn't found in the container (should
    # never happen if the MIDI::Measures object is up to date).
    def measure_for_event(e)
      detect { |m| m.contains_event?(e) }
    end

    # Returns the event's time as a formatted MBT string (Measure:Beat:Ticks)
    # as found in MIDI sequencers.
    def to_mbt(e)
      m = measure_for_event(e)
      b = (e.time_from_start.to_f - m.start.to_f) / @ppqd
      b *= 24 / m.metronome_ticks
      sprintf("%d:%02d:%03d", m.measure_number, b.to_i + 1, (b - b.to_i) * @ppqd)
    end
  end

end

module MIDI

  # Number of MIDI channels
  MIDI_CHANNELS = 16
  # Number of note per MIDI channel
  NOTES_PER_CHANNEL = 128

  #--
  # Standard MIDI File meta event defs.
  #++
  META_EVENT = 0xff
  META_SEQ_NUM = 0x00
  META_TEXT = 0x01
  META_COPYRIGHT = 0x02
  META_SEQ_NAME = 0x03
  META_INSTRUMENT = 0x04
  META_LYRIC = 0x05
  META_MARKER = 0x06
  META_CUE = 0x07
  META_MIDI_CHAN_PREFIX = 0x20
  META_TRACK_END = 0x2f
  META_SET_TEMPO = 0x51
  META_SMPTE = 0x54
  META_TIME_SIG = 0x58
  META_KEY_SIG = 0x59
  META_SEQ_SPECIF = 0x7f

  #--
  # Channel messages
  #++
  # Note, val
  NOTE_OFF = 0x80
  # Note, val
  NOTE_ON = 0x90
  # Note, val
  POLY_PRESSURE = 0xA0
  # Controller #, val
  CONTROLLER = 0xB0
  # Program number
  PROGRAM_CHANGE = 0xC0
  # Channel pressure
  CHANNEL_PRESSURE = 0xD0
  # LSB, MSB
  PITCH_BEND = 0xE0

  #--
  # System common messages
  #++
  # System exclusive start
  SYSEX = 0xF0
  # Beats from top: LSB/MSB 6 ticks = 1 beat
  SONG_POINTER = 0xF2
  # Val = number of song
  SONG_SELECT = 0xF3
  # Tune request
  TUNE_REQUEST = 0xF6
  # End of system exclusive
  EOX = 0xF7

  #--
  # System realtime messages
  #++
  # MIDI clock (24 per quarter note)
  CLOCK = 0xF8
  # Sequence start
  START = 0xFA
  # Sequence continue
  CONTINUE = 0xFB
  # Sequence stop
  STOP = 0xFC
  # Active sensing (sent every 300 ms when nothing else being sent)
  ACTIVE_SENSE = 0xFE
  # System reset
  SYSTEM_RESET = 0xFF

  # Controller numbers
  # = 0 - 31 = continuous, LSB
  # = 32 - 63 = continuous, MSB
  # = 64 - 97 = switches
  CC_MOD_WHEEL = 1
  CC_BREATH_CONTROLLER = 2
  CC_FOOT_CONTROLLER = 4
  CC_PORTAMENTO_TIME = 5
  CC_DATA_ENTRY_MSB = 6
  CC_VOLUME = 7
  CC_BALANCE = 8
  CC_PAN = 10
  CC_EXPRESSION_CONTROLLER = 11
  CC_GEN_PURPOSE_1 = 16
  CC_GEN_PURPOSE_2 = 17
  CC_GEN_PURPOSE_3 = 18
  CC_GEN_PURPOSE_4 = 19

  # [32 - 63] are LSB for [0 - 31]
  CC_DATA_ENTRY_LSB = 38

  #--
  # Momentaries:
  #++
  CC_SUSTAIN = 64
  CC_PORTAMENTO = 65
  CC_SUSTENUTO = 66
  CC_SOFT_PEDAL = 67
  CC_HOLD_2 = 69
  CC_GEN_PURPOSE_5 = 50
  CC_GEN_PURPOSE_6 = 51
  CC_GEN_PURPOSE_7 = 52
  CC_GEN_PURPOSE_8 = 53
  CC_TREMELO_DEPTH = 92
  CC_CHORUS_DEPTH = 93
  CC_DETUNE_DEPTH = 94
  CC_PHASER_DEPTH = 95
  CC_DATA_INCREMENT = 96
  CC_DATA_DECREMENT = 97
  CC_NREG_PARAM_LSB = 98
  CC_NREG_PARAM_MSB = 99
  CC_REG_PARAM_LSB = 100
  CC_REG_PARAM_MSB = 101

  #--
  # Channel mode message values
  #++
  # Val 0 == off, 0x7f == on
  CM_LOCAL_CONTROL = 0x7A
  CM_ALL_NOTES_OFF = 0x7B # Val must be 0
  CM_OMNI_MODE_OFF = 0x7C # Val must be 0
  CM_OMNI_MODE_ON = 0x7D  # Val must be 0
  CM_MONO_MODE_ON = 0x7E  # Val = # chans
  CM_POLY_MODE_ON = 0x7F  # Val must be 0

  # Controller names
  CONTROLLER_NAMES = [
    "0",
    "Modulation",
    "Breath Control",
    "3",
    "Foot Controller",
    "Portamento Time",
    "Data Entry",
    "Volume",
    "Balance",
    "9",
    "Pan",
    "Expression Control",
    "12", "13", "14", "15",
    "General Controller 1",
    "General Controller 2",
    "General Controller 3",
    "General Controller 4",
    "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
    "30", "31",
    "32", "33", "34", "35", "36", "37", "38", "39", "40", "41",
    "42", "43", "44", "45", "46", "47", "48", "49", "50", "51",
    "52", "53", "54", "55", "56", "57", "58", "59", "60", "61",
    "62", "63",
    "Sustain Pedal",
    "Portamento",
    "Sostenuto",
    "Soft Pedal",
    "68",
    "Hold 2",
    "70", "71", "72", "73", "74", "75", "76", "77", "78", "79",
    "General Controller 5",
    "Tempo Change",
    "General Controller 7",
    "General Controller 8",
    "84", "85", "86", "87", "88", "89", "90",
    "External Effects Depth",
    "Tremolo Depth",
    "Chorus Depth",
    "Detune (Celeste) Depth",
    "Phaser Depth",
    "Data Increment",
    "Data Decrement",
    "Non-Registered Param LSB",
    "Non-Registered Param MSB",
    "Registered Param LSB",
    "Registered Param MSB",
    "102", "103", "104", "105", "106", "107", "108", "109",
    "110", "111", "112", "113", "114", "115", "116", "117",
    "118", "119", "120",
    "Reset All Controllers",
    "Local Control",
    "All Notes Off",
    "Omni Mode Off",
    "Omni Mode On",
    "Mono Mode On",
    "Poly Mode On"
  ]

  # General MIDI patch names
  GM_PATCH_NAMES = [
    #--
    # Pianos
    #++
    "Acoustic Grand Piano",
    "Bright Acoustic Piano",
    "Electric Grand Piano",
    "Honky-tonk Piano",
    "Electric Piano 1",
    "Electric Piano 2",
    "Harpsichord",
    "Clavichord",
    #--
    # Tuned Idiophones
    #++
    "Celesta",
    "Glockenspiel",
    "Music Box",
    "Vibraphone",
    "Marimba",
    "Xylophone",
    "Tubular Bells",
    "Dulcimer",
    #--
    # Organs
    #++
    "Drawbar Organ",
    "Percussive Organ",
    "Rock Organ",
    "Church Organ",
    "Reed Organ",
    "Accordion",
    "Harmonica",
    "Tango Accordion",
    #--
    # Guitars
    #++
    "Acoustic Guitar (nylon)",
    "Acoustic Guitar (steel)",
    "Electric Guitar (jazz)",
    "Electric Guitar (clean)",
    "Electric Guitar (muted)",
    "Overdriven Guitar",
    "Distortion Guitar",
    "Guitar harmonics",
    #--
    # Basses
    #++
    "Acoustic Bass",
    "Electric Bass (finger)",
    "Electric Bass (pick)",
    "Fretless Bass",
    "Slap Bass 1",
    "Slap Bass 2",
    "Synth Bass 1",
    "Synth Bass 2",
    #--
    # Strings
    #++
    "Violin",
    "Viola",
    "Cello",
    "Contrabass",
    "Tremolo Strings",
    "Pizzicato Strings",
    "Orchestral Harp",
    "Timpani",
    #--
    # Ensemble strings and voices
    #++
    "String Ensemble 1",
    "String Ensemble 2",
    "SynthStrings 1",
    "SynthStrings 2",
    "Choir Aahs",
    "Voice Oohs",
    "Synth Voice",
    "Orchestra Hit",
    #--
    # Brass
    #++
    "Trumpet",
    "Trombone",
    "Tuba",
    "Muted Trumpet",
    "French Horn",
    "Brass Section",
    "SynthBrass 1",
    "SynthBrass 2",
    #--
    # Reeds
    #++
    "Soprano Sax",		# 64
    "Alto Sax",
    "Tenor Sax",
    "Baritone Sax",
    "Oboe",
    "English Horn",
    "Bassoon",
    "Clarinet",
    #--
    # Pipes
    #++
    "Piccolo",
    "Flute",
    "Recorder",
    "Pan Flute",
    "Blown Bottle",
    "Shakuhachi",
    "Whistle",
    "Ocarina",
    #--
    # Synth Leads
    #++
    "Lead 1 (square)",
    "Lead 2 (sawtooth)",
    "Lead 3 (calliope)",
    "Lead 4 (chiff)",
    "Lead 5 (charang)",
    "Lead 6 (voice)",
    "Lead 7 (fifths)",
    "Lead 8 (bass + lead)",
    #--
    # Synth Pads
    #++
    "Pad 1 (new age)",
    "Pad 2 (warm)",
    "Pad 3 (polysynth)",
    "Pad 4 (choir)",
    "Pad 5 (bowed)",
    "Pad 6 (metallic)",
    "Pad 7 (halo)",
    "Pad 8 (sweep)",
    #--
    # Effects
    #++
    "FX 1 (rain)",
    "FX 2 (soundtrack)",
    "FX 3 (crystal)",
    "FX 4 (atmosphere)",
    "FX 5 (brightness)",
    "FX 6 (goblins)",
    "FX 7 (echoes)",
    "FX 8 (sci-fi)",
    #--
    # Ethnic
    #++
    "Sitar",
    "Banjo",
    "Shamisen",
    "Koto",
    "Kalimba",
    "Bag pipe",
    "Fiddle",
    "Shanai",
    #--
    # Percussion
    #++
    "Tinkle Bell",
    "Agogo",
    "Steel Drums",
    "Woodblock",
    "Taiko Drum",
    "Melodic Tom",
    "Synth Drum",
    "Reverse Cymbal",
    #--
    # Sound Effects
    #++
    "Guitar Fret Noise",
    "Breath Noise",
    "Seashore",
    "Bird Tweet",
    "Telephone Ring",
    "Helicopter",
    "Applause",
    "Gunshot"
  ]

  # GM drum notes start at 35 (C), so subtrack GM_DRUM_NOTE_LOWEST from your
  # note number before using this array.
  GM_DRUM_NOTE_LOWEST = 35
  # General MIDI drum channel note names.
  GM_DRUM_NOTE_NAMES = [
    "Acoustic Bass Drum",	# 35, C
    "Bass Drum 1",		# 36, C#
    "Side Stick",		# 37, D
    "Acoustic Snare",           # 38, D#
    "Hand Clap",		# 39, E
    "Electric Snare",           # 40, F
    "Low Floor Tom",            # 41, F#
    "Closed Hi Hat",            # 42, G
    "High Floor Tom",           # 43, G#
    "Pedal Hi-Hat",		# 44, A
    "Low Tom",                  # 45, A#
    "Open Hi-Hat",		# 46, B
    "Low-Mid Tom",		# 47, C
    "Hi Mid Tom",		# 48, C#
    "Crash Cymbal 1",           # 49, D
    "High Tom",                 # 50, D#
    "Ride Cymbal 1",            # 51, E
    "Chinese Cymbal",           # 52, F
    "Ride Bell",		# 53, F#
    "Tambourine",		# 54, G
    "Splash Cymbal",            # 55, G#
    "Cowbell",                  # 56, A
    "Crash Cymbal 2",           # 57, A#
    "Vibraslap",		# 58, B
    "Ride Cymbal 2",            # 59, C
    "Hi Bongo",                 # 60, C#
    "Low Bongo",		# 61, D
    "Mute Hi Conga",            # 62, D#
    "Open Hi Conga",            # 63, E
    "Low Conga",		# 64, F
    "High Timbale",		# 65, F#
    "Low Timbale",		# 66, G
    "High Agogo",		# 67, G#
    "Low Agogo",		# 68, A
    "Cabasa",                   # 69, A#
    "Maracas",                  # 70, B
    "Short Whistle",            # 71, C
    "Long Whistle",		# 72, C#
    "Short Guiro",		# 73, D
    "Long Guiro",		# 74, D#
    "Claves",                   # 75, E
    "Hi Wood Block",            # 76, F
    "Low Wood Block",           # 77, F#
    "Mute Cuica",		# 78, G
    "Open Cuica",		# 79, G#
    "Mute Triangle",            # 80, A
    "Open Triangle"		# 81, A#
  ]

end


if RUBY_VERSION < '1.9'
  class IO
    def readbyte
      c = getc()
      raise 'unexpected EOF' unless c
      c
    end
  end
end

module MIDI

  module IO

    # A MIDIFile parses a MIDI file and calls methods when it sees MIDI events.
    # Most of the methods are stubs. To do anything interesting with the events,
    # override these methods (those between the "The rest of these are NOPs by
    # default" and "End of NOPs" comments).
    #
    # See SeqReader for a subclass that uses these methods to create Event
    # objects.
    class MIDIFile

      MThd_BYTE_ARRAY = [77, 84, 104, 100] # "MThd"
      MTrk_BYTE_ARRAY = [77, 84, 114, 107] # "MTrk"

      # This array is indexed by the high half of a status byte. Its
      # value is either the number of bytes needed (1 or 2) for a channel
      # message, or 0 if it's not a channel message.
      NUM_DATA_BYTES = [
	0, 0, 0, 0, 0, 0, 0, 0, # 0x00 - 0x70
	2, 2, 2, 2, 1, 1, 2, 0  # 0x80 - 0xf0
      ]

      attr_accessor  :curr_ticks	# Current time, from delta-time in MIDI file
      attr_accessor  :ticks_so_far # Number of delta-time ticks so far
      attr_accessor  :bytes_to_be_read # Counts number of bytes expected

      attr_accessor  :no_merge	# true means continued sysex are not collapsed
      attr_accessor  :skip_init	# true if initial garbage should be skipped

      # Raw data info
      attr_accessor  :raw_time_stamp_data
      attr_accessor  :raw_var_num_data
      attr_accessor  :raw_data

      def initialize
	@no_merge = false
	@skip_init = true
	@io = nil
	@bytes_to_be_read = 0
	@msg_buf = nil
      end

      # The only public method. Each MIDI event in the file causes a
      # method to be called.
      def read_from(io)
	error('must specify non-nil input stream') if io.nil?
	@io = io

	ntrks = read_header()
	error('No tracks!') if ntrks <= 0

	ntrks.times { read_track() }
      end

      # This default getc implementation tries to read a single byte
      # from io and returns it as an integer.
      def getc
        @bytes_to_be_read -= 1
        @io.readbyte()
      end

      # Return the next +n+ bytes from @io as an array.
      def get_bytes(n)
	buf = []
	n.times { buf << getc() }
	buf
      end

      # The default error handler.
      def error(str)
	loc = @io.tell() - 1
	raise "#{self.class.name} error at byte #{loc} (0x#{'%02x' % loc}): #{str}"
      end

      # The rest of these are NOPs by default.

      # MIDI header.
      def header(format, ntrks, division)
      end

      def start_track(bytes_to_be_read)
      end

      def end_track()
      end

      def note_on(chan, note, vel)
      end

      def note_off(chan, note, vel)
      end

      def pressure(chan, note, press)
      end

      def controller(chan, control, value)
      end

      def pitch_bend(chan, msb, lsb)
      end

      def program(chan, program)
      end

      def chan_pressure(chan, press)
      end

      def sysex(msg)
      end

      def meta_misc(type, msg)
      end

      def sequencer_specific(type, msg)
      end

      def sequence_number(num)
      end

      def text(type, msg)
      end

      def eot()
      end

      def time_signature(numer, denom, clocks, qnotes)
      end

      def smpte(hour, min, sec, frame, fract)
      end

      def tempo(microsecs)
      end

      def key_signature(sharpflat, is_minor)
      end

      def arbitrary(msg)
      end

      # End of NOPs.


      # Read through 'MThd' or 'MTrk' header string. If skip is true, attempt
      # to skip initial trash. If there is an error, #error is called.
      def read_mt_header_string(bytes, skip)
	b = []
	bytes_to_read = 4
	while true
          data = get_bytes(bytes_to_read)
          b += data
          if b.length < 4
            error("unexpected EOF while trying to read header string #{s}")
          end

          # See if we found the bytes we're looking for
          return if b == bytes

          if skip		# Try again with the next char
            i = b[1..-1].index(bytes[0])
            if i.nil?
              b = []
              bytes_to_read = 4
            else
              b = b[i..-1]
              bytes_to_read = 4 - i
            end
          else
            error("header string #{bytes.collect{|b| b.chr}.join} not found")
          end
	end
      end

      # Read a header chunk.
      def read_header
	@bytes_to_be_read = 0
	read_mt_header_string(MThd_BYTE_ARRAY, @skip_init) # "MThd"

	@bytes_to_be_read = read32()
	format = read16()
	ntrks = read16()
	division = read16()

	header(format, ntrks, division)

	# Flush any extra stuff, in case the length of the header is not 6
	if @bytes_to_be_read > 0
          get_bytes(@bytes_to_be_read)
          @bytes_to_be_read = 0
	end

	return ntrks
      end

      # Read a track chunk.
      def read_track
	c = c1 = type = needed = 0
	sysex_continue = false	# True if last msg was unfinished
	running = false		# True when running status used
	status = 0		# (Possibly running) status byte

	@bytes_to_be_read = 0
	read_mt_header_string(MTrk_BYTE_ARRAY, false)

	@bytes_to_be_read = read32()
	@curr_ticks = @ticks_so_far = 0

	start_track()

	while @bytes_to_be_read > 0
          @curr_ticks = read_var_len() # Delta time
          @ticks_so_far += @curr_ticks

          # Copy raw var num data into raw time stamp data
          @raw_time_stamp_data = @raw_var_num_data.dup()

          c = getc()		# Read first byte

          if sysex_continue && c != EOX
            error("didn't find expected continuation of a sysex")
          end

          if (c & 0x80).zero? # Running status?
            error('unexpected running status') if status.zero?
            running = true
          else
            status = c
            running = false
          end

          needed = NUM_DATA_BYTES[(status >> 4) & 0x0f]

          if needed.nonzero?	# i.e., is it a channel message?
            c1 = running ? c : (getc() & 0x7f)

            # The "& 0x7f" here may seem unnecessary, but I've seen
            # "bad" MIDI files that had, for example, volume bytes
            # with the upper bit set. This code should not harm
            # proper data.
            chan_message(running, status, c1,
                         (needed > 1) ? (getc() & 0x7f) : 0)
            next
          end

          case c
          when META_EVENT	# Meta event
            type = getc()
            msg_init()
            msg_read(read_var_len())
            meta_event(type)
          when SYSEX		# Start of system exclusive
            msg_init()
            msg_add(SYSEX)
            c = msg_read(read_var_len())

            if c == EOX || !@no_merge
              handle_sysex(msg())
            else
              sysex_continue = true
            end
          when EOX		# Sysex continuation or arbitrary stuff
            msg_init() if !sysex_continue
            c = msg_read(read_var_len())

            if !sysex_continue
              handle_arbitrary(msg())
            elsif c == EOX
              handle_sysex(msg())
              sysex_continue = false
            end
          else
            bad_byte(c)
          end
	end
	end_track()
      end

      # Handle an unexpected byte.
      def bad_byte(c)
	error(sprintf("unexpected byte: 0x%02x", c))
      end

      # Handle a meta event.
      def meta_event(type)
	m = msg()		# Copy of internal message buffer

	# Create raw data array
	@raw_data = []
	@raw_data << META_EVENT
	@raw_data << type
	@raw_data << @raw_var_num_data
	@raw_data << m
	@raw_data.flatten!

	case type
	when META_SEQ_NUM
          sequence_number((m[0] << 8) + m[1])
	when META_TEXT, META_COPYRIGHT, META_SEQ_NAME, META_INSTRUMENT,
          META_LYRIC, META_MARKER, META_CUE, 0x08, 0x09, 0x0a,
          0x0b, 0x0c, 0x0d, 0x0e, 0x0f
          text(type, m)
	when META_TRACK_END
          eot()
	when META_SET_TEMPO
          tempo((m[0] << 16) + (m[1] << 8) + m[2])
	when META_SMPTE
          smpte(m[0], m[1], m[2], m[3], m[4])
	when META_TIME_SIG
          time_signature(m[0], m[1], m[2], m[3])
	when META_KEY_SIG
          key_signature(m[0], m[1] == 0 ? false : true)
	when META_SEQ_SPECIF
          sequencer_specific(type, m)
	else
          meta_misc(type, m)
	end
      end

      # Handle a channel message (note on, note off, etc.)
      def chan_message(running, status, c1, c2)
	@raw_data = []
	@raw_data << status unless running
	@raw_data << c1
	@raw_data << c2

	chan = status & 0x0f

	case (status & 0xf0)
	when NOTE_OFF
          note_off(chan, c1, c2)
	when NOTE_ON
          note_on(chan, c1, c2)
	when POLY_PRESSURE
          pressure(chan, c1, c2)
	when CONTROLLER
          controller(chan, c1, c2)
	when PITCH_BEND
          pitch_bend(chan, c1, c2)
	when PROGRAM_CHANGE
          program(chan, c1)
	when CHANNEL_PRESSURE
          chan_pressure(chan, c1)
	else
          error("illegal chan message 0x#{'%02x' % (status & 0xf0)}\n")
	end
      end

      # Copy message into raw data array, then call sysex().
      def handle_sysex(msg)
	@raw_data = msg.dup()
	sysex(msg)
      end

      # Copy message into raw data array, then call arbitrary().
      def handle_arbitrary(msg)
	@raw_data = msg.dup()
	arbitrary(msg)
      end

      # Read and return a sixteen bit value.
      def read16
	val = (getc() << 8) + getc()
	val = -(val & 0x7fff) if (val & 0x8000).nonzero?
	return val
      end

      # Read and return a 32-bit value.
      def read32
	val = (getc() << 24) + (getc() << 16) + (getc() << 8) +
          getc()
	val = -(val & 0x7fffffff) if (val & 0x80000000).nonzero?
	return val
      end

      # Read a varlen value.
      def read_var_len
	@raw_var_num_data = []
	c = getc()
	@raw_var_num_data << c
	val = c
	if (val & 0x80).nonzero?
          val &= 0x7f
          while true
            c = getc()
            @raw_var_num_data << c
            val = (val << 7) + (c & 0x7f)
            break if (c & 0x80).zero?
          end
	end
	return val
      end

      # Write a sixteen-bit value.
      def write16(val)
	val = (-val) | 0x8000 if val < 0
	putc((val >> 8) & 0xff)
	putc(val & 0xff)
      end

      # Write a 32-bit value.
      def write32(val)
	val = (-val) | 0x80000000 if val < 0
	putc((val >> 24) & 0xff)
	putc((val >> 16) & 0xff)
	putc((val >> 8) & 0xff)
	putc(val & 0xff)
      end

      # Write a variable length value.
      def write_var_len(val)
	if val.zero?
          putc(0)
          return
	end

	buf = []

	buf << (val & 0x7f)
	while (value >>= 7) > 0
          buf << (val & 0x7f) | 0x80
	end

	buf.reverse.each { |b| putc(b) }
      end

      # Add a byte to the current message buffer.
      def msg_add(c)
	@msg_buf << c
      end

      # Read and add a number of bytes to the message buffer. Return
      # the last byte (so we can see if it's an EOX or not).
      def msg_read(n_bytes)
	@msg_buf += get_bytes(n_bytes)
	@msg_buf.flatten!
	return @msg_buf[-1]
      end

      # Initialize the internal message buffer.
      def msg_init
	@msg_buf = []
      end

      # Return a copy of the internal message buffer.
      def msg
	return @msg_buf.dup()
      end

    end

  end
end


module MIDI

  module IO

    # Reads MIDI files. As a subclass of MIDIFile, this class implements the
    # callback methods for each MIDI event and use them to build Track and
    # Event objects and give the tracks to a Sequence.
    #
    # We append new events to the end of a track's event list, bypassing a
    # call to Track.#add. This means that we must call Track.recalc_times at
    # the end of the track so it can update each event with its time from
    # the track's start (see end_track below).
    #
    # META_TRACK_END events are not added to tracks. This way, we don't have
    # to worry about making sure the last event is always a track end event.
    # We rely on the SeqWriter to append a META_TRACK_END event to each
    # track when it is output.

    class SeqReader < MIDIFile

      # The optional proc block is called once at the start of the file and
      # again at the end of each track. There are three arguments to the
      # block: the track, the track number (1 through _n_), and the total
      # number of tracks.
      def initialize(seq, proc = nil) # :yields: track, num_tracks, index
	super()
	@seq = seq
	@track = nil
	@chan_mask = 0
	@update_block = block_given?() ? Proc.new() : proc
      end

      def header(format, ntrks, division)
	@seq.format = format
	@seq.ppqn = division

	@ntrks = ntrks
	@update_block.call(nil, @ntrks, 0) if @update_block
      end

      def start_track()
	@track = Track.new(@seq)
	@seq.tracks << @track

	@pending = []
      end

      def end_track()
	# Turn off any pending note on messages
	@pending.each { |on| make_note_off(on, 64) }
	@pending = nil

	# Don't bother adding the META_TRACK_END event to the track.
	# This way, we don't have to worry about making sure the
	# last event is always a track end event.

	# Let the track calculate event times from start of track. This is
	# in lieu of calling Track.add for each event.
	@track.recalc_times()

	# Store bitmask of all channels used into track
	@track.channels_used = @chan_mask

	# call update block
	@update_block.call(@track, @ntrks, @seq.tracks.length) if @update_block
      end

      def note_on(chan, note, vel)
	if vel == 0
          note_off(chan, note, 64)
          return
	end

	on = NoteOn.new(chan, note, vel, @curr_ticks)
	@track.events << on
	@pending << on
	track_uses_channel(chan)
      end

      def note_off(chan, note, vel)
	# Find note on, create note off, connect the two, and remove
	# note on from pending list.
	@pending.each_with_index do |on, i|
          if on.note == note && on.channel == chan
            make_note_off(on, vel)
            @pending.delete_at(i)
            return
          end
	end
	$stderr.puts "note off with no earlier note on (ch #{chan}, note" +
          " #{note}, vel #{vel})" if $DEBUG
      end

      def make_note_off(on, vel)
	off = NoteOff.new(on.channel, on.note, vel, @curr_ticks)
	@track.events << off
	on.off = off
	off.on = on
      end

      def pressure(chan, note, press)
	@track.events << PolyPressure.new(chan, note, press, @curr_ticks)
	track_uses_channel(chan)
      end

      def controller(chan, control, value)
	@track.events << Controller.new(chan, control, value, @curr_ticks)
	track_uses_channel(chan)
      end

      def pitch_bend(chan, lsb, msb)
	@track.events << PitchBend.new(chan, (msb << 7) + lsb, @curr_ticks)
	track_uses_channel(chan)
      end

      def program(chan, program)
	@track.events << ProgramChange.new(chan, program, @curr_ticks)
	track_uses_channel(chan)
      end

      def chan_pressure(chan, press)
	@track.events << ChannelPressure.new(chan, press, @curr_ticks)
	track_uses_channel(chan)
      end

      def sysex(msg)
	@track.events << SystemExclusive.new(msg, @curr_ticks)
      end

      def meta_misc(type, msg)
	@track.events << MetaEvent.new(type, msg, @curr_ticks)
      end

      # --
      #      def sequencer_specific(type, msg)
      #      end

      #      def sequence_number(num)
      #      end
      # ++

      def text(type, msg)
	case type
        when META_TEXT, META_LYRIC, META_CUE
          @track.events << MetaEvent.new(type, msg, @curr_ticks)
	when META_SEQ_NAME, META_COPYRIGHT
          @track.events << MetaEvent.new(type, msg, 0)
	when META_INSTRUMENT
          @track.instrument = msg
	when META_MARKER
          @track.events << Marker.new(msg, @curr_ticks)
	else
          $stderr.puts "text = #{msg}, type = #{type}" if $DEBUG
	end
      end

      # --
      # Don't bother adding the META_TRACK_END event to the track. This way,
      # we don't have to worry about always making sure the last event is
      # always a track end event. We just have to make sure to write one when
      # the track is output back to a file.
      #  	def eot()
      #  	    @track.events << MetaEvent.new(META_TRACK_END, nil, @curr_ticks)
      #  	end
      # ++

      def time_signature(numer, denom, clocks, qnotes)
	@seq.time_signature(numer, denom, clocks, qnotes)
        @track.events << TimeSig.new(numer, denom, clocks, qnotes, @curr_ticks)
      end

      # --
      #      def smpte(hour, min, sec, frame, fract)
      #      end
      # ++

      def tempo(microsecs)
	@track.events << Tempo.new(microsecs, @curr_ticks)
      end

      def key_signature(sharpflat, is_minor)
        @track.events << KeySig.new(sharpflat, is_minor, @curr_ticks)
      end

      # --
      #      def arbitrary(msg)
      #      end
      # ++

      # Return true if the current track uses the specified channel.
      def track_uses_channel(chan)
	@chan_mask = @chan_mask | (1 << chan)
      end

    end

  end
end


module MIDI

  module IO

    class SeqWriter

      def initialize(seq, proc = nil) # :yields: num_tracks, index
	@seq = seq
	@update_block = block_given?() ? Proc.new() : proc
      end

      # Writes a MIDI format 1 file.
      def write_to(io)
	@io = io
	@bytes_written = 0
	write_header()
	@update_block.call(nil, @seq.tracks.length, 0) if @update_block
	@seq.tracks.each_with_index do |track, i|
          write_track(track)
          @update_block.call(track, @seq.tracks.length, i) if @update_block
	end
      end

      def write_header
	@io.print 'MThd'
	write32(6)
	write16(1)		# Ignore sequence format; write as format 1
	write16(@seq.tracks.length)
	write16(@seq.ppqn)
      end

      def write_track(track)
	@io.print 'MTrk'
	track_size_file_pos = @io.tell()
	write32(0)		# Dummy byte count; overwritten later
	@bytes_written = 0	# Reset after previous write

	write_instrument(track.instrument)

	prev_event = nil
	prev_status = 0
	track.events.each do |event|
          if !event.kind_of?(Realtime)
            write_var_len(event.delta_time)
          end

          data = event.data_as_bytes()
          status = data[0] # status byte plus channel number, if any

          # running status byte
          status = possibly_munge_due_to_running_status_byte(data, prev_status)

          @bytes_written += write_bytes(data)

          prev_event = event
          prev_status = status
	end

	# Write track end event.
	event = MetaEvent.new(META_TRACK_END)
	write_var_len(0)
	@bytes_written += write_bytes(event.data_as_bytes())

	# Go back to beginning of track data and write number of bytes,
	# then come back here to end of file.
	@io.seek(track_size_file_pos)
	write32(@bytes_written)
	@io.seek(0, ::IO::SEEK_END)
      end

      # If we can use a running status byte, delete the status byte from
      # the given data. Return the status to remember for next time as the
      # running status byte for this event.
      def possibly_munge_due_to_running_status_byte(data, prev_status)
	status = data[0]
	return status if status >= 0xf0 || prev_status >= 0xf0

	chan = (status & 0x0f)
	return status if chan != (prev_status & 0x0f)

	status = (status & 0xf0)
	prev_status = (prev_status & 0xf0)

	# Both events are on the same channel. If the two status bytes are
	# exactly the same, the rest is trivial. If it's note on/note off,
	# we can combine those further.
	if status == prev_status
          data[0,1] = []	# delete status byte from data
          return status + chan
	elsif status == NOTE_OFF && data[2] == 64
          # If we see a note off and the velocity is 64, we can store
          # a note on with a velocity of 0. If the velocity isn't 64
          # then storing a note on would be bad because the would be
          # changed to 64 when reading the file back in.
          data[2] = 0		# set vel to 0; do before possible shrinking
          status = NOTE_ON + chan
          if prev_status == NOTE_ON
            data[0,1] = []	# delete status byte
          else
            data[0] = status
          end
          return status
	else
          # Can't compress data
          return status + chan
	end
      end

      def write_instrument(instrument)
	event = MetaEvent.new(META_INSTRUMENT, instrument)
	write_var_len(0)
	data = event.data_as_bytes()
	@bytes_written += write_bytes(data)
      end

      def write_var_len(val)
	buffer = Utils.as_var_len(val)
	@bytes_written += write_bytes(buffer)
      end

      def write16(val)
	val = (-val | 0x8000) if val < 0

	buffer = []
	@io.putc((val >> 8) & 0xff)
	@io.putc(val & 0xff)
	@bytes_written += 2
      end

      def write32(val)
	val = (-val | 0x80000000) if val < 0

	@io.putc((val >> 24) & 0xff)
	@io.putc((val >> 16) & 0xff)
	@io.putc((val >> 8) & 0xff)
	@io.putc(val & 0xff)
	@bytes_written += 4
      end

      def write_bytes(bytes)
	bytes.each { |b| @io.putc(b) }
	bytes.length
      end
    end

  end
end


begin
	$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')
EE=[1,2,3,4,5,6,7,8,10,9,11,12,13,14,15,0]
seq = Sequence.new()
@quarter_note_length = seq.note_to_delta('quarter')
$music=Array.new {  } #音色,音调,始时,终时,音量#############################################
$musi= Array.new {  } #始终,时间,音色,音调,音量s
$time=0
$tim=0
$ti=[]
$mus=[[]]
$message=[]
$pb=[]
def yc(t,a)
   $track[a].events << NoteOff.new(0, 0, 0, t)
end
def j (test,a)
	$time=$tim
	#print test
	test.each { |e|#print "\n\n",e,"\n\n\n"
	#	print e[0][0].class,e[0][0].class.class
		if e.length==4 && e[2].is_a?(Integer) 
				e[0].length.times { |n| 
				$music[a]<< [0,e[0][n],$time+((n+0.5-e[0].length/2)*e[3]).to_i,$time+(e[1]*@quarter_note_length).to_i,e[2]]

		}
	$time+=(e[1]*@quarter_note_length).to_i
else
					$timee=$time
					e.each { |ee| 	ee[0].length.times{ |n| 
				$music[a]<< [0,ee[0][n],$timee+((n+0.5-ee[0].length/2)*ee[3]).to_i,$timee+(ee[1]*@quarter_note_length).to_i,ee[2]]

		}
	$timee+=(ee[1]*@quarter_note_length).to_i }
				

	end
		  }
end
def com_st(a,b,e,n)
			if b-a<=1
					$musi[n].insert(a,[true,e[2],e[0],e[1],e[4]])
		
		elsif $musi[n][((a+b-2)/2).to_i][1]<=e[2]
		com_st(((a+b)/2).to_i,b,e,n)
	else
		com_st(a,((a+b)/2).to_i,e,n)
end
end
def com_en(a,b,e,n)
			if b-a<=1
					$musi[n].insert(a,[false,e[3],e[0],e[1],e[4]])
					
		
		elsif $musi[n][((a+b-2)/2).to_i][1]<e[3]
		com_en(((a+b)/2).to_i,b,e,n)
	else
		com_en(a,((a+b)/2).to_i,e,n)
end
end
def hx(i=0,type='M-',period=1,bet=0,volume=127)
	is4 =false
	case type
	when "M+"
		a=[-8,-5,0]
	when "M-"
		a=[-5,0,4]
	when 'M'
		a=[0,4,7]
	when "m+"
		a=[-9,-5,0]
	when "m-"
		a=[-5,0,3]
	when 'm'
		a=[0,3,7]
	when "M7"
		is4=true
		a=[0,4,7,11]
	when "M7-"
		is4=true
		a=[-1,0,3,7]
	when "M7+"
		is4=true
		a=[-8,-5,-1,0]
	when "M7++"
		is4=true
		a=[-5,-1,0,3]
	when "m7"
		is4=false
		a=[0,3,7,11]
	when "m7+"
		is4=true
		a=[-9,-5,-1,0]
	when "m7++"
		is4=true
		a=[-5,-1,0,3]
	when "m7-"
		is4=true
		a=[-1,0,3,7]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "MM"
		is4=false
		a=[0,4,7,12]
	end
	$track.events << NoteOn.new(0, i+a[0], volume, 0)
	if(bet!=0)
		yc(bet)
	end
	$track.events << NoteOn.new(0, i+a[1] , volume, 0)
	if(bet!=0)
		yc(bet)
	end
	$track.events << NoteOn.new(0, i+a[2] , volume, 0)
	if(bet!=0)
		yc(bet)
	end
	if is4
		$track.events << NoteOn.new(0, i+a[3] , volume, 0)
	end
$track.events << NoteOff.new(0, i +a[0], volume, period*@quarter_note_length-3*bet)
$track.events << NoteOff.new(0, i +a[0], volume, 0)
$track.events << NoteOff.new(0, i +a[1], volume, 0)
if is4
   $track.events << NoteOff.new(0, i +a[2], volume, 0)
end
end
file=Dir["*.txt"]
#print "\n\n\n",file,"\n\n\n"
if file.length==0
	puts "哎呀,你还没有任何.txt文件可以导入\n文件不仅可以导入,也可以写在程序里面哦!\n写一个属于你自己的音乐吧"
	system"pause"
	exit
else
	puts "本程序由大连理工大学软英1605张金哲设计\n输入你要读取的文件:"
	@m=[]
	str=File.read("moren.ini")
	file.each { |e| 
		@m<<e
	 print e,"\n" }
	 print "默认文件：",str,"\n"
	@e=gets
	unless (@m.include?@e.chomp!) || (@m.include?(@e<<".txt"))
		@e=str
	end
	File.open("moren.ini", 'w') { |file| file.print @e }
		@a=""
		arr = IO.readlines(@e)
		arr.each{|block|
		 if block.lstrip=="" 
		 	if @a!=""
			@u=0
		 					@a.gsub!(/[\[\]\(\)\{\}]/) { |match|" #{match} "}
			$mus[-1]<<@a
			@a=""
		else 
			$mus<<[]
		 	end
		else
			@a<<block+"|"
		end }
		if @a!=""
			$mus[-1]<<@a
		end

end
$jj={ 
'a'=>60,
's'=>62,
'd'=>64,
'f'=>65,
'g'=>-1,
'h'=>-2,
'j'=>67,
'k'=>69,
'l'=>71,
';'=>72,


'q'=>72,
'w'=>74,
'e'=>76,
'r'=>77,
't'=>-3,
'y'=>-4,
'u'=>79,
'i'=>81,
'o'=>83,
'p'=>84,


'z'=>48,
'x'=>50,
'c'=>52,
'v'=>53,
'b'=>-5,
'n'=>-6,
'm'=>55,
','=>57,
'.'=>59,
'/'=>60,


'1'=>84,
'2'=>86,
'3'=>88,
'4'=>89,
'5'=>-7,
'6'=>-8,
'7'=>91,
'8'=>93,
'9'=>95,
'0'=>96,


'-'=>-9,
'='=>-10,


'A'=>61,
'S'=>63,
'D'=>-31,
'F'=>66,
'G'=>-11,
'H'=>-12,
'J'=>68,
'K'=>70,
'L'=>-32,
':'=>73,


'Q'=>73,
'W'=>75,
'E'=>-33,
'R'=>78,
'T'=>-13,
'Y'=>-14,
'U'=>80,
'I'=>82,
'O'=>-34,
'P'=>85,


'Z'=>49,
'X'=>51,
'C'=>-35,
'V'=>54,
'B'=>-15,
'N'=>-16,
'M'=>56,
'<'=>58,
'>'=>-36,
'?'=>61,


'!'=>85,
'@'=>87,
'#'=>-37,
'$'=>90,
'%'=>-17,
'^'=>-18,
'&'=>92,
'*'=>94,
'('=>-38,
')'=>-39,


'_'=>-19,
'+'=>-20,
'['=>-21,
']'=>-22,
'\''=>-23,
'"'=>-24,
'|'=>-25}



def mj
	pp||=0
	$mus.each { |eee|  #e角标 
		pp+=1
		if eee==[]
			$tim=$time
			#print $tim
			if $mus[pp] !=[]
				$pb<<$music.length
			end
			next
		end
		$a||=0
		@qq||=0
	$music<<[]
		$message<<eee[0][0,6]
	eee[0]=eee[0][6..-1]
	eee.each { |e|	
	m=[]
	mm=[]
		@ts||=false
		@tss||=false
	@sd=e[0,3].to_i
	#print @sd
		@yl=100
		@dlek=@dlekk=@jq=0
		@jpp=1.0
		@slykg=false
		@pp=0
		@jpjsq=0
		@ss=""
		e[3..-1].split.each{|c|
		q=0
		@rr=1
		@p=@pp
		@r=0
		@jp=0.5
		n=[]
		jc=false
			@ss+=c.gsub(/\|/,"")+" "
			while q<c.length 
			if @wy==true
				if c[q]==')'
					case @wyl.length
					when 0
					when 1
						16.times { |n| 
						mm<<[[204],@wyl[0].to_f/2048,8192*n/16+8192,0] }
					when 2
						16.times { |n|
						mm<<[[204],@wyl[0].to_f/2048,8192+@wyl[1]*n/16,0]  }
					else
						(@wyl.length-2).times{ |nn|
							16.times{ |n|
								mm<<[[204],@wyl[0].to_f/(2048*(@wyl.length-2)),8192+(@wyl[1+nn]*(16-n)+@wyl[2+nn]*n)/16,0]
							}
						}
					end
					#print @wyl,"\n\n",mm,"\n\n"
					@tss=true
				else
					@wyl<<c[q..q+4].to_i
					#print @wyl,"\n\n",mm,"\n\n"
					q+=5
					next
				end
			end
		@wy=false
		@wyl=[]
			if $jj[c[q]]>0 
				n<<$jj[c[q]]+@sd
					jc=true

			else

				case $jj[c[q]]
				when -1			#g加半拍
					@jp+=0.5
					jc=true
				when -2			#h减为一半
					@jp/=2
					jc=true
				when -13		#T三连音开关
					if @slykg
					@jpp*=1.5
					@slykg=false
					else
					@jpp/=1.5
					@slykg=true
					end
				when -12
					@jpp/=2
				when -11
					@jpp*=2
				when -3			#t增加一倍
					@jp*=2
					jc=true
				when -4			#y琶音
					@p+=(@quarter_note_length/24).to_i
				when -14			#Y连琶音
					@pp+=(@quarter_note_length/24).to_i
					@p+=(@quarter_note_length/24).to_i
				when -5			#b减弱音量
					@yl-=8
				when -7			#5增加音量
					@yl+=8
				when -8			#6升调
					@sd+=1
				when -6			#n降调
					@sd-=1
				when -15		#B渐弱
					@jq-=1
				when -17		#%渐强
					@jq+=1
				when -16			#N大降调
					@sd-=12
				when -18			#^大升调
					@sd+=12
				when -23		#'断点
					@dlek+=1
				when -24		#"断点
					@dlek-=1
				when -32		#L连续
					@dlekk,@dlek=@dlek,@dlekk
				when -21		#[]同时 sdf [mggg ] sd
					@ts=true
					#print "ts=true\n"
				when -22
					@tss=true
				when -31	#D
					if @ts
						mm<<[[201],0,c[q+1..q+3].to_i,0]
					else
						m<<[[201],0,c[q+1..q+3].to_i,0]
					end
					q+=3
				when -33		#E
					if @ts
						mm<<[[200],0,c[q+1..q+3].to_i,0]
					else
						m<<[[200],0,c[q+1..q+3].to_i,0]
					end
					q+=3
				when -35	#C声相
					if @ts
						mm<<[[203],0,c[q+1..q+3].to_i,0]
					else
						m<<[[203],0,c[q+1..q+3].to_i,0]
					end
					q+=3
				when -36	#>
					if $jj[c[q+1]]==-36
						@rr+=1
					else
					if @ts
						mm<<[[$jj[c[q+1]]],@rr.to_f/24,@yl,0]
					else
						m<<[[$jj[c[q+1]]],@rr.to_f/24,@yl,0]
					end
					q+=1
					@r+=@rr# 断音的时长	
					@rr=1
					end
				when -34
					if @ts
						mm<<[[202],0,c[q+1..q+3].to_i,0]
					else
						m<<[[202],0,c[q+1..q+3].to_i,0]
					end
					q+=3
				when -37	##
					break
				when -38	#弯音轮
					@wy=true
					@ts=true
				when -25
					if @jpjsq%4!=0 && @jpjsq!=2
					print @jpjsq,"!!!!!   ",@ss,"\n"
				else
					puts @jpjsq
					end
					@jpjsq=0
					@ss=""
				end



				
			end
			q+=1
			
			end
			@yl+=(@jq*@jp*2).to_i
					#print "##",m,"haha\n",@ts
					if jc
									if @ts
			if @dlek!=0
	if @dlek+@r*1.5>@jp*@jpp*14
mm<<[n,@jp*@jpp/8-@r.to_f/24,@yl,@p]
mm<<[[],@jp*0.875*@jpp,0,0]
	else
mm<<[n,@jp*@jpp-@dlek*0.0625-@r.to_f/24,@yl,@p]
mm<<[[],@dlek*0.0625,0,0]
end
else

mm<<[n,@jp*@jpp-@dlek*0.0625-@r.to_f/24,@yl,@p]
end
			else
				#print "hehe\n\n"
				if @dlek!=0
	if @dlek+@r>@jp*@jpp*14
m<<[n,@jp*@jpp/8-@r.to_f/24,@yl,@p]
m<<[[],@jp*@jpp*0.875,0,0]
	else
m<<[n,@jp*@jpp-@dlek*0.0625-@r.to_f/24,@yl,@p]
m<<[[],@dlek*0.0625,0,0]
end
else

m<<[n,@jp*@jpp-@dlek*0.0625-@r.to_f/24,@yl,@p]
end
			end
		@jpjsq+=@jp*@jpp
					end

if @tss
	@ts=false
	#print "##",m,"haha\n"
	#print "**",mm,"\n"
	m<<mm
	mm=[]
	@tss=false
end
#print m,"asdf"
}
j(m,@qq)
	  }
@qq+=1
}
end
mj
#print $music,"  213123123123"


$time=0
$music.each { |q|$c||=0
	$musi<<[] 
	 q.length.times { |n|  
com_st(0,n*2+1,q[n],$c)
com_en(0,n*2+2,q[n],$c)
 } 
 $c+=1 }
$track=[]
ee||=0
eet||=0  #track[eet]
yjs =0  #音节数
#print $pb,"\n"
#print $musi,"\n"
$musi.length.times { |eetx|
if $pb.include? (eetx)
	#print "include",eetx
	eet = 0
end
if eet>=yjs
	$track << Track.new(seq)
#print "$track[#{eet}].events << MetaEvent.new(META_SEQ_NAME, \"music track#{ee}\") "
seq.tracks << $track[eet]
yjs+=1
$ti<<0
end
$track[eet==0 ? 0 : eet-1].events << Tempo.new(Tempo.bpm_to_mpq($message[eetx][3,3].to_i))#
#print "$track[",eet,"].events << Tempo.new(Tempo.bpm_to_mpq(",$message[eetx][3,3].to_i,"))"
###########节拍

if ($message[eetx][0,3].to_i==0) ##打击乐器
eee =9
else
	eee=ee;
	  ee=EE[ee]
	$track[eet].events << ProgramChange.new(eee, $message[eetx][0,3].to_i-1)###############音色

end
	w=Array.new(120) {[0,0]}
$musi[eetx].each { |e|
	if e[3]==200
		if e[0]
			$track[eet].events << ProgramChange.new(eee,e[4]-1)
		end
	elsif e[3]==201
		if e[0]
			$track[eet].events << Tempo.new(Tempo.bpm_to_mpq(e[4].to_i))
			#print "$track[",eet,"].events << Tempo.new(Tempo.bpm_to_mpq(",e[4].to_i,"))"
		end
	elsif e[3]==202
		if e[0]
			$track[eet].events << Controller.new(eee,7,e[4])
		end
	elsif e[3]==203
		if e[0]
			$track[eet].events << Controller.new(eee,10,e[4])
		end
	elsif e[3]==204
		if e[0]
			$track[eet].events << PitchBend.new(eee,e[4], e[1]-$time-$ti[eet])
	$ti[eet]=0
$time=e[1]
		end
			
	else
			




	if e[0]
w[e[3]][0]+=1
		if w[e[3]][0]==0
			$track[eet].events << NoteOn.new(eee, e[3],e[4], e[1]-$time-$ti[eet])
#print $ti[eet],"  "
	$ti[eet]=0
=begin
			print "$track[ee].events << NoteOn.new(",eee,"," ,e[3],"," ,e[4],", ",e[1]-$time,")\n"
print "w[",e[3],"][0]=",w[e[3]][0],"\n"
=end
else
$track[eet].events << NoteOff.new(eee, e[3], w[e[3]][1], e[1]-$time-$ti[eet])
$track[eet].events << NoteOn.new(eee, e[3], e[4], 0)
#print $ti[eet],"  "
	$ti[eet]=0
=begin
	print "$track[ee].events << NoteOff.new(",eee,"," ,e[3],"," ,w[e[3]][1],", ",e[1]-$time,")\n"
		print "$track[ee].events << NoteOn.new(",eee,"," ,e[3],"," ,e[4],", ",0,")\n"
		print "w[",e[3],"][0]=",w[e[3]][0],"\n"
=end
		end
	
w[e[3]][1]=e[4]
$time=e[1]
	else
	w[e[3]][0]-=1
	if w[e[3]][0]<1
	$track[eet].events << NoteOff.new(eee, e[3], e[4], e[1]-$time-$ti[eet])
	#print $ti[eet],"  "
	$ti[eet]=0
=begin
	print "$track[ee].events << NoteOff.new(",eee,"," ,e[3],"," ,e[4],", ",e[1]-$time,")\n"
		print "w[",e[3],"][0]=",w[e[3]][0],"\n"
=end
$time=e[1]
	end
	end



	end
	  }
	$ti[eet]=$musi[eetx][-1][1]
	  $time=0
	  #print ee,"::",EE[ee],"\n"
	  #print ee
	eet+=1}
	#print $ti
File.open(@e[0..-5]+".mid", 'wb') { |file| seq.write(file) }
system "wmplayer #{File.dirname(__FILE__)}\\#{@e[0..-5]}.mid"
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
system "pause"
end