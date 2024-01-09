raw_yuv_file = Path.expand("./test/support/images/image.yuv")
{:ok, binary} = File.read(raw_yuv_file)
{:ok, image} = Image.YUV.new_from_binary(binary, 1920, 1080, :C420, :bt601)

# For testing resize performance
red = image[0]

Benchee.run(
  %{
    "Converting YUV 4:2:0 binary in BT601 to an RGB image" => fn ->
      {:ok, _i} = Image.YUV.new_from_binary(binary, 1920, 1080, :C420, :bt601)
    end,

    "Converting an RGB image to YUV 4:2:0 binary in BT601" => fn ->
      {:ok, _} = Image.YUV.write_to_binary(image, :C420, :bt601)
    end,

    "Encode an RGB image as YUV 4:2:2" => fn ->
      Image.YUV.encode(image, :C420)
    end,

    "Scale a plane to 1/2 size for 4:2:0" => fn ->
      Image.YUV.new_scaled_plane(red, 0.5, 0.5)
    end
  },
  time: 20,
  memory_time: 2
)