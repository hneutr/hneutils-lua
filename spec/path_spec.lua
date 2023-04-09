require 'busted.runner'()

describe("path", function()
    before_each(function()
        path = require('util.path')
    end)

    describe("exists", function()
        it("does", function()
            assert(path.exists("/Users/hne/Desktop"))
        end)

        it("doesn't", function()
            assert.is_false(path.exists("steve"))
        end)
    end)

end)
