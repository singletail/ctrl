import os, sys
from PIL import Image, ImageFile


def print_info(img):
    print("size: ")
    print(img.size)
    print("format: ")
    print(img.format)
    print("mode: ")
    print(img.mode)


def convert_to_blp_v1(infile, outfile):
    with Image.open(infile) as im:
        print_info(im)
        im.convert(mode="P", palette=Image.ADAPTIVE, colors=256).save(
            outfile, blp_version=["BLP1"]
        )


def convert_to_blp_v2(infile, outfile):
    with Image.open(infile) as im:
        print_info(im)
        im.convert(mode="P", palette=Image.ADAPTIVE, colors=256).save(
            outfile, blp_version=["BLP2"]
        )


def convert_to_png(infile, outfile):
    with Image.open(infile) as im:
        print_info(im)
        im.convert(mode="RGBA").save(outfile)


def test_to_blp_v1():
    infile = "/Applications/World of Warcraft/_retail_/Interface/AddOns/ctrl/assets/test/Metal.png"
    outfile = "/Applications/World of Warcraft/_retail_/Interface/AddOns/ctrl/assets/test/Metal1.blp"
    convert_to_blp_v1(infile, outfile)


def test_to_blp_v2():
    infile = "/Applications/World of Warcraft/_retail_/Interface/AddOns/ctrl/assets/test/Metal.png"
    outfile = "/Applications/World of Warcraft/_retail_/Interface/AddOns/ctrl/assets/test/Metal2.blp"
    convert_to_blp_v2(infile, outfile)


def test_to_png():
    infile = "/Applications/World of Warcraft/_retail_/Interface/AddOns/ctrl/assets/ctrl/m1_v2.blp"
    outfile = "/Applications/World of Warcraft/_retail_/Interface/AddOns/ctrl/assets/ctrl/m1_v2.png"
    convert_to_png(infile, outfile)


if __name__ == "__main__":
    # infile = "/Applications/World of Warcraft/_retail_/Interface/AddOns/ctrl/assets/ctrl/m1.png"
    # outfile = "/Applications/World of Warcraft/_retail_/Interface/AddOns/ctrl/assets/ctrl/m1_v2.blp"

    # if len(sys.argv) != 3:
    #    print("Usage: python blp.py <infile> <outfile>")
    #    sys.exit(1)

    # infile = sys.argv[1]
    # outfile = sys.argv[2]

    # if not os.path.exists(infile):
    #    print(f"File {infile} does not exist")
    #    sys.exit(1)

    test_to_blp_v1()
    test_to_blp_v2()
    # test_to_png()


# python blp.py /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/ctrl/assets/1999/metal.png /Applications/World\ of\ Warcraft/_retail_/Interface/AddOns/ctrl/assets/1999/metal.blp
