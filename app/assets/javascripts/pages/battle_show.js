window.showBattle = function(arena_width) {

    // Init app
    window.app = new Vue({
        el: '#app',
        data: {
            currentRound: 0,
            rounds: window.gon.rounds,
            totalRounds: window.gon.rounds.length,
            nowPlaying: false,
            playInterval: null,
            sneks: window.gon.sneks
        },
        methods: {
            renderRound: function () {
                this.resetArena();
                var _this = this;
                var sneks = this.rounds[this.currentRound].sneks;
                var direction_code = '';
                var cell_html = '';
                sneks.forEach(function(snek, snek_number){
                    snek.position.forEach(function (position, index) {
                        direction_code = _this.directionClass(index, snek);
                        if(index == 0) {
                            cell_html = '<img src="' + gon.sneks[snek.snek_id].style.head + '" class="' + direction_code + '" title="' + gon.sneks[snek.snek_id].name + '">';
                            $('#c_' + position.x + '_' + position.y).html(cell_html);
                        } else if (index != (snek.position.length - 1) ) {
                            if( snek.position[index-1].x != snek.position[index+1].x && snek.position[index-1].y != snek.position[index+1].y ) {
                                cell_html = '<img src="' + gon.sneks[snek.snek_id].style.curve + '" class="' + direction_code + '">';
                                cell_html += '<img src="' + gon.sneks[snek.snek_id].style.curve_pattern + '" class="' + direction_code + '">';
                                $('#c_' + position.x + '_' + position.y).html(cell_html);
                            } else {
                                cell_html = '<img src="' + gon.sneks[snek.snek_id].style.body + '" class="' + direction_code + '">';
                                cell_html += '<img src="' + gon.sneks[snek.snek_id].style.body_pattern + '" class="' + direction_code + '">';
                                $('#c_' + position.x + '_' + position.y).html(cell_html);
                            }
                        } else {
                            cell_html = '<img src="' + gon.sneks[snek.snek_id].style.tail + '" class="' + direction_code + '">';
                            cell_html += '<img src="' + gon.sneks[snek.snek_id].style.tail_pattern + '" class="' + direction_code + '">';
                            $('#c_' + position.x + '_' + position.y).html(cell_html);
                        }
                    });
                });

            },

            nextRound: function(){
                this.stop();
                if(this.currentRound < (this.totalRounds - 1) ) {
                    this.currentRound++;
                }
            },

            prevRound: function() {
                this.stop();
                if(this.currentRound > 0) {
                    this.currentRound--;
                }
            },

            gotoBeginning: function(){
                this.stop();
                this.currentRound = 0;
            },

            gotoEnd: function(){
                this.stop();
                this.currentRound = this.rounds.length - 1;
            },

            play: function() {
                _this = this;
                _this.playInterval = setInterval(function(){
                    if(_this.currentRound < (_this.totalRounds - 1) ) {
                        _this.currentRound++;
                    } else {
                        _this.nowPlaying = false;
                    }
                }, 100);
            },

            stop: function() {
                if(this.playInterval ) {
                    clearInterval(this.playInterval);
                    _this.nowPlaying = false;
                }
            },

            /**
             * @return String
             */
            getSnekName: function(pos) {
                return snek_names[pos];
            },

            /**
             * Get cell direction CSS class
             */
            directionClass: function(position_index, snek_data) {
                var position = snek_data.position;
                var prev = position[position_index - 1];
                var curr = position[position_index];
                var next = position[position_index + 1];

                // Head
                if(prev == null) {
                    if (next.x === curr.x) {
                        if (next.y > curr.y) {
                            return 'cell-up';
                        } else {
                            return 'cell-down';
                        }
                    } else if (next.y === curr.y) {
                        if (next.x > curr.x) {
                            return 'cell-left';
                        } else {
                            return 'cell-right';
                        }
                    }
                }

                // Tail
                if (next == null) {
                    if (prev.x === curr.x) {
                        if (prev.y > curr.y) {
                            return 'cell-down';
                        } else {
                            return 'cell-up';
                        }
                    } else if (prev.y === curr.y) {
                        if (prev.x > curr.x) {
                            return 'cell-right';
                        } else {
                            return 'cell-left';
                        }
                    }
                }

                // Body
                if( prev && next && curr ) {
                    // Horizontal
                    if( prev.y === next.y ) {
                        return 'cell-left';
                        // Vertical
                    } else if (prev.x === next.x ) {
                        return 'cell-up';
                        // Will be curve
                    } else {

                        // Position ⌝. Don't rotate
                        if (prev.y === curr.y && prev.y < next.y && prev.x < curr.x && curr.x === next.x) {
                            return 'cell-left';
                        }
                        if (next.y === curr.y && next.y < prev.y && next.x < curr.x && curr.x === prev.x) {
                            return 'cell-left';
                        }

                        // Position ⌜.
                        if (prev.y === curr.y && prev.y < next.y && prev.x > curr.x && curr.x === next.x) {
                            return 'cell-down';
                        }
                        if (next.y === curr.y && next.y < prev.y && next.x > curr.x && curr.x === prev.x) {
                            return 'cell-down';
                        }

                        // Position ⌞.
                        if (prev.y === curr.y && prev.y > next.y && prev.x > curr.x && curr.x === next.x) {
                            return 'cell-right';
                        }
                        if (next.y === curr.y && next.y > prev.y && next.x > curr.x && curr.x === prev.x) {
                            return 'cell-right';
                        }

                        // Position ⌟.
                        if (prev.y === curr.y && prev.y > next.y && prev.x < curr.x && curr.x === next.x) {
                            return 'cell-up';
                        }
                        if (next.y === curr.y && next.y > prev.y && next.x < curr.x && curr.x === prev.x) {
                            return 'cell-up';
                        }

                    }

                }

                return '';
            },

            resetArena: function() {
                $('#arena table.arena-container td.empty').empty();
            }

        },

        computed: {
            snekTail: function(idx) {
                console.log("IDX: " + idx);
                return gon.sneks[index].style.tail;
            },
            snekBody: function(idx) {
                return gon.sneks[idx].style.body;
            },
            snekHead: function(idx) {
                return gon.sneks[idx].style.head;
            }
        },

        watch: {
            currentRound: function(value) {
                this.renderRound();
            },

            nowPlaying: function(value) {
                if(value) {
                    this.play();
                } else {
                    this.stop();
                }
            }
        }

    });

    // On window resize
    $(document).ready(resizeArena);
    $(window).resize(resizeArena);

    // Resize patterns cells
    function resizeArena() {
        var cell_width = parseInt($('#arena table.arena-container').width() / arena_width);
        $('#arena table.arena-container td').width(cell_width);
        $('#arena table.arena-container td').height(cell_width);
    }

    // Run it
    window.app.renderRound();

};