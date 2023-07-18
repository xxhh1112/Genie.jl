using Pkg
Pkg.activate(".")

using Genie, Genie.Router, Genie.Renderer, Genie.Renderer.Html

form = """
<form action="/" method="POST" enctype="multipart/form-data">
  <input type="text" name="greeting" value="hello genie" /><br/>
  <input type="file" name="fileupload" /><br/>
  <input type="submit" value="Submit" />
</form>
"""

route("/") do
  html(form)
end

route("/", method = POST) do
  for (name,file) in params(:files)
    write(file.name, IOBuffer(file.data))
  end

  write("-" * params(:files)["fileupload"].name, IOBuffer(params(:files)["fileupload"].data))

  params(:greeting)
end

Genie.Server.up(; open_browser = false, async = false)
