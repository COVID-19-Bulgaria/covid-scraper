# frozen_string_literal: true

module FileHelpers
  def write_file(filename:, data:)
    IO.write(filename, data, 0, mode: 'w')
  end

  def build_database_file_path(*path)
    File.join(
      ENV['COVID_DATABASE_PATH_CONTAINER'],
      path
    )
  end
end
