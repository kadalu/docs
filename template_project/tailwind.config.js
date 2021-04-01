module.exports = {
    purge: [
        './layouts/**/*.html',
        './content/**/*.html',
        './content/**/*.erb',
        './content/**/*.md',
        './content/**/*.adoc'
    ],
    darkMode: false, // or 'media' or 'class'
    theme: {
        extend: {},
    },
    variants: {
        extend: {},
    },
    plugins: [],
}
