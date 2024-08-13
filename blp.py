import os, sys
from PIL import Image

for infile in sys.argv[1:]:
    f, e = os.path.splitext(infile)
    outfile = f + ".blp"
    if infile != outfile:
        try:
            with Image.open(infile) as im:
                im.convert(mode="P", palette=Image.ADAPTIVE, colors=256).save(
                    outfile, blp_version=["BLP2"]
                )
                # im.convert("RGB").save(outfile, "BLP")
                # im.save(outfile, blp_version=["BLP2"])
        except OSError:
            print("cannot convert", infile)

# python blp.py /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/ctrl/assets/1999/metal.png /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/ctrl/assets/1999/metal.blp
