module Hbc
  class CLI
    class InternalDump < InternalUseBase
      def self.run(*arguments)
        cask_tokens = cask_tokens_from(arguments)
        raise CaskUnspecifiedError if cask_tokens.empty?
        retval = dump_casks(*cask_tokens)
        # retval is ternary: true/false/nil

        raise CaskError, "nothing to dump" if retval.nil?
        raise CaskError, "dump incomplete" unless retval
      end

      def self.dump_casks(*cask_tokens)
        CLI.debug = true # Yuck. At the moment this is the only way to make dumps visible
        count = 0
        cask_tokens.each do |cask_token|
          begin
            cask = CaskLoader.load(cask_token)
            count += 1
            cask.dumpcask
          rescue StandardError => e
            opoo "#{cask_token} was not found or would not load: #{e}"
          end
        end
        count.zero? ? nil : count == cask_tokens.length
      end

      def self.help
        "dump the given Cask in YAML format"
      end
    end
  end
end
