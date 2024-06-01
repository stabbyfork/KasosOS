local bit32 = require("bit32")

-- SHA-256 Constants
local H = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
}

local K = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

local function band(a, b) return bit32.band(a, b) end
local function bor(a, b) return bit32.bor(a,b) end
local function bxor(a, b) return bit32.bxor(a, b) end
local function rshift(a, n) return bit32.rshift(a, n) end
local function lshift(a, n) return bit32.lshift(a, n) end
local function bnot(a) return bit32.bnot(a) end

--- Converts string to bits
---@param str string Any string
---@return table bits Table with bits of the string
local function to_bits(str)
    local bits = {}
    for i = 1, #str do
        local c = str:byte(i)
        for j = 7, 0, -1 do
            table.insert(bits, band(rshift(c, j), 1))
        end
    end
    return bits
end

--- Converts a table of bits to a table of bytes
---@param bits table A table of bits (0 or 1)
---@return table bytes A table of bytes
local function to_bytes(bits)
    local bytes = {}
    for i = 1, #bits, 8 do
        local byte = 0
        for j = 0, 7 do
            byte = bor(lshift(byte, 1), bits[i + j] or 0)
        end
        table.insert(bytes, byte)
    end
    return bytes
end

--- Converts a hexadecimal string to a table of bytes
---@param hex string Hexadecimal string
---@return table bytes A table of bytes
local function hex_to_bytes(hex)
    local bytes = {}
    for i = 1, #hex, 2 do
        table.insert(bytes, tonumber(hex:sub(i, i + 1), 16))
    end
    return bytes
end

--- Converts a table of bytes to a hexadecimal string
---@param bytes table A table of bytes
---@return string hex A hexadecimal string
local function bytes_to_hex(bytes)
    local hex = {}
    for _, byte in ipairs(bytes) do
        table.insert(hex, string.format("%02x", byte))
    end
    return table.concat(hex)
end

--- Pads a table of bits
---@param bits table A table of bits
---@param length integer The length of the table of bits
---@return table pad A table of padded bits
local function pad(bits, length)
    local pad_len = (448 - length - 1) % 512 + 1
    local pad = {1}
    for i = 1, pad_len do
        table.insert(pad, 0)
    end
    for i = 56, 1, -8 do
        table.insert(pad, band(rshift(length, i - 1), 0xff))
    end
    for i = 0, 7 do
        table.insert(pad, band(rshift(length, i * 8), 0xff))
    end
    return pad
end

--- Generates a SHA-256 hash
---@param msg string Any string
---@return string hash A SHA-256 hash
local function sha256(msg)
    local bits = to_bits(msg)
    local length = #bits
    bits = {table.unpack(bits), table.unpack(pad(bits, length))}

    local chunks = {}
    for i = 1, #bits, 512 do
        table.insert(chunks, {table.unpack(bits, i, i + 511)})
    end

    for _, chunk in ipairs(chunks) do
        local w = {}
        for i = 1, 16 do
            w[i] = 0
            for j = 0, 31 do
                w[i] = bor(lshift(w[i], 1), chunk[(i - 1) * 32 + j + 1] or 0)
            end
        end

        for i = 17, 64 do
            local s0 = bxor(rshift(w[i - 15], 7), bxor(rshift(w[i - 15], 18), rshift(w[i - 15], 3)))
            local s1 = bxor(rshift(w[i - 2], 17), bxor(rshift(w[i - 2], 19), rshift(w[i - 2], 10)))
            w[i] = (w[i - 16] + s0 + w[i - 7] + s1) % 2^32
        end

        local a, b, c, d, e, f, g, h = table.unpack(H)

        for i = 1, 64 do
            local S1 = bxor(rshift(e, 6), bxor(rshift(e, 11), rshift(e, 25)))
            local ch = bxor(band(e, f), band(bnot(e), g))
            local temp1 = (h + S1 + ch + K[i] + w[i]) % 2^32
            local S0 = bxor(rshift(a, 2), bxor(rshift(a, 13), rshift(a, 22)))
            local maj = bxor(band(a, b), bxor(band(a, c), band(b, c)))
            local temp2 = (S0 + maj) % 2^32

            h = g
            g = f
            f = e
            e = (d + temp1) % 2^32
            d = c
            c = b
            b = a
            a = (temp1 + temp2) % 2^32
        end

        H[1] = (H[1] + a) % 2^32
        H[2] = (H[2] + b) % 2^32
        H[3] = (H[3] + c) % 2^32
        H[4] = (H[4] + d) % 2^32
        H[5] = (H[5] + e) % 2^32
        H[6] = (H[6] + f) % 2^32
        H[7] = (H[7] + g) % 2^32
        H[8] = (H[8] + h) % 2^32
    end

    local hash = {}
    for _, h in ipairs(H) do
        for i = 0, 3 do
            table.insert(hash, band(rshift(h, (3 - i) * 8), 0xff))
        end
    end

    return bytes_to_hex(hash)
end

-- XOR encryption
---@param input string The string to be encrypted
---@param key string The key string
---@return string encrypted_string The encrypted string
local function xor_encrypt(input, key)
    local output = {}
    for i = 1, #input do
        local key_byte = key:byte((i - 1) % #key + 1)
        local input_byte = input:byte(i)
        table.insert(output, string.char(bxor(input_byte, key_byte)))
    end
    return table.concat(output)
end

--- Generate a key from a string
---@param input_string string
---@return string
local function generate_key_from_string(input_string)
    return sha256(input_string)
end

--- Encrypt a string using the provided key
---@param input_string string
---@param key string
---@return string encrypted_string The encrypted hex string
local function encrypt_string(input_string, key)
    return xor_encrypt(input_string, key)
end

--[[--- Decrypt a string using the provided key
---@param encrypted_string string
---@param key string
---@return string decrypted_string The decrypted string
local function decrypt_string(encrypted_string, key)
    return xor_encrypt(encrypted_string, key)
end--]]

-- Example usage
local input_string = "password122"
local key = generate_key_from_string(input_string)
local encrypted_string = encrypt_string(input_string, key)
--local decrypted_string = decrypt_string(encrypted_string, key)

--print("Original String: " .. input_string)
--print("Key (hex): " .. key)
--print("Encrypted String (hex): " .. bytes_to_hex({encrypted_string:byte(1, #encrypted_string)}))
--print("Decrypted String: " .. decrypted_string)
