var gulp = require('gulp');
var minifyJS = require('gulp-minify');
var cleanCSS = require('gulp-clean-css');
var minifyHTML = require('gulp-htmlmin');

// Minify Javascript
gulp.task('minify_js', function(){
	gulp.src("../priv/static/js/*.js")
		.pipe(minifyJS({
			ext:{
				min: ".min.js"
			}
		}))
		.pipe(gulp.dest("../priv/static/js"));
});

// Minify CSS
gulp.task('minify_css', () => {
  return gulp.src('../priv/static/css/*.css')
    .pipe(cleanCSS({debug: true}, function(details) {
      console.log(details.name + ': ' + details.stats.originalSize);
      console.log(details.name + ': ' + details.stats.minifiedSize);
    }))
  .pipe(gulp.dest('../priv/static/css'));
});

// Minify HTML
gulp.task('minify_html', () => {
	var options = {
		collapseWhitespace: true
	};
	gulp.src('../lib/red_pack_productions/web/templates/**/*.eex').pipe(minifyHTML(options)).pipe(gulp.dest('../lib/red_pack_productions/web/templates'));
});

// Minify all in one go!
gulp.task('minify_all', ['minify_js', 'minify_css']);