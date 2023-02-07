from flask import abort


def get_paginated_list(url, start, limit, count):
    if count < start:
        abort(404)
    # make response
    obj = {}
    obj["start"] = start
    obj["limit"] = limit
    obj["count"] = count
    # make URLs
    # make previous url
    if start == 1:
        obj["previous"] = ""
    else:
        start_copy = max(1, start - limit)
        limit_copy = start - 1
        obj["previous"] = f"{url}/{start_copy}/{limit_copy}"
        # obj['previous'] = url + '?start=%d&limit=%d' % (start_copy, limit_copy)
    # make next url
    if start + limit > count:
        obj["next"] = ""
    else:
        start_copy = start + limit
        obj["next"] = f"{url}/{start_copy}/{limit}"
        # obj['next'] = url + '?start=%d&limit=%d' % (start_copy, limit)
    # finally extract result according to bounds
    # obj['results'] = results[(start - 1):(start - 1 + limit)]
    return obj
