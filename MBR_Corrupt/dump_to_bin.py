import argparse

def read_from_end_and_save(file_path, num_bytes, output_file):
    try:
        with open(file_path, 'rb') as file:
            file.seek(-num_bytes, 2)
            data = file.read(num_bytes)

        with open(output_file, 'wb') as out_file:
            out_file.write(data)

        return True
    except Exception as e:
        print(f"An error occurred: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Read a specified number of bytes from the end of a file and save to a new file.')
    parser.add_argument('-i', '--input', required=True, help='Input file path')
    parser.add_argument('-o', '--output', required=True, help='Output file path')
    parser.add_argument('-s', '--size', type=int, required=True, help='Number of bytes to read from the end of the file')

    args = parser.parse_args()

    success = read_from_end_and_save(args.input, args.size, args.output)
    if success:
        print(f"Last {args.size} bytes from {args.input} have been saved to {args.output}.")
    else:
        print("Failed to process the file.")

if __name__ == "__main__":
    main()

