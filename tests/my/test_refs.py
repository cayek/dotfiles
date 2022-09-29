from my.refs import Refs

def test_refs_capture():

    # given
    # uri = 'https://www.facebook.com/favicon.ico'
    uri = 'https://jonathan-hui.medium.com/map-mean-average-precision-for-object-detection-45c121a31173'
    title = "test"
    idd = "abcd"

    # with
    refs = Refs("~/Private/refs")

    # then
    refs.archive(uri, idd, title)
